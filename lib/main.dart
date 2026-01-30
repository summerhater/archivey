import 'dart:async';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/data/service/firebase_shared_category_link_service.dart';
import 'package:archivey/data/service/kakao_sdk_share_service.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:archivey/firebase_options.dart';
import 'package:archivey/routing/go_router.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:archivey/ui/setting/view_model/setting_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './mobile_conditional_import.dart'
  if (dart.library.html) './web_conditional_import.dart';

import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initPathUrlStrategy();
  KakaoSdk.init(
    nativeAppKey: 'cb606197f0f386e941b49506653d6e87',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final db = AppDatabase.instance;
  final keyHash = await KakaoSdk.origin;
  print("실제 등록할 키 해시: $keyHash");
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),

          Provider<AppDatabase>.value(
            value: db,
          ),
          Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
          Provider<FirebaseAppUserService>(
            create: (_) => FirebaseAppUserService(),
          ),
          Provider<DriftDocumentService>(create: (_) => DriftDocumentService(db)),
          Provider<FirebaseDocumentService>(
            create: (_) => FirebaseDocumentService(),
          ),
          Provider<FirebaseCategoryService>(
            create: (_) => FirebaseCategoryService(),
          ),
          Provider<KakaoSdkShareService>(create: (_) => KakaoSdkShareService(),),
          Provider<FirebaseSharedCategoryWebService>(
            create: (_) => FirebaseSharedCategoryWebService(),
          ),
          ChangeNotifierProvider<AuthViewModel>(
            create: (context) => AuthViewModel(
              context.read<FirebaseAuthService>(),
              context.read<FirebaseAppUserService>(),
              context.read<AppState>(),
            ),
            lazy: false,
          ),
          // ChangeNotifierProxyProvider<AppState, AuthViewModel>(
          //   create: (context) {
          //     return AuthViewModel(
          //       context.read<FirebaseAuthService>(),
          //       context.read<FirebaseAppUserService>(),
          //       context.read<AppState>(),
          //     );
          //   },
          //   update: (context, appState, previous) {
          //     if (previous == null) throw Exception('AuthVM 생성 안됨');
          //
          //     previous.updateState(appState);
          //
          //     return previous;
          //   },
          //   lazy: false,
          // ),

          ChangeNotifierProvider<DocumentViewModel>(
            create: (context) => DocumentViewModel(
              context.read<FirebaseDocumentService>(),
            ),
          ),
          ChangeNotifierProvider<CategoryViewModel>(
            create: (context) => CategoryViewModel(
              context.read<FirebaseCategoryService>(),
              context.read<KakaoSdkShareService>(),
              context.read<AppState>(),
              context.read<FirebaseDocumentService>(),
              context.read<DriftDocumentService>(),
              context.read<FirebaseSharedCategoryWebService>(),
            ),
          ),
          // ChangeNotifierProxyProvider<AppState, CategoryViewModel>(
          //   create: (context) => CategoryViewModel(
          //     context.read<FirebaseCategoryService>(),
          //     context.read<AppState>(),
          //     context.read<FirebaseDocumentService>(),
          //     context.read<DriftDocumentService>(),
          //     context.read<FirebaseSharedCategoryWebService>(),
          //   ),
          //   update: (context, appState, previous) {
          //     if (previous == null) throw Exception('CategoryVM 생성 안됨');
          //
          //     previous.updateState(appState);
          //
          //     return previous;
          //   },
          // ),
          // setting VM
          ChangeNotifierProvider<SettingViewModel>(
            create: (context) => SettingViewModel(
              context.read<FirebaseAuthService>(),
              context.read<FirebaseAppUserService>(),
              context.read<AppState>(),
            ),
          ),
          // ChangeNotifierProxyProvider<AppState, SettingViewModel>(
          //   create: (context) => SettingViewModel(
          //     context.read<FirebaseAuthService>(),
          //     context.read<FirebaseAppUserService>(),
          //     context.read<AppState>(),
          //   ),
          //   update: (context, appState, previous) {
          //     if (previous == null) throw Exception('SettingVM 생성 안됨');
          //
          //     previous.updateState(appState);
          //
          //     return previous;
          //   },
          // ),
          // 테스트용 VM
          ChangeNotifierProvider<DocViewModel>(
            create: (context) => DocViewModel(
              context.read<FirebaseDocumentService>(),
              context.read<DriftDocumentService>(),
              context.read<KakaoSdkShareService>(),
              context.read<AppState>(),
            ),
          ),
          // ChangeNotifierProxyProvider<AppState, DocViewModel>(
          //   create: (context) => DocViewModel(
          //     context.read<FirebaseDocumentService>(),
          //     context.read<DriftDocumentService>(),
          //     context.read<AppState>(),
          //   ),
          //   update: (context, appState, previous) {
          //     if (previous == null) throw Exception('DocVM 생성 안됨');
          //
          //     previous.updateState(appState);
          //
          //     return previous;
          //   },
          // ),
        ],
        child: const Archivey(),
      ),
    );
}

class Archivey extends StatefulWidget {
  const Archivey({super.key});

  @override
  State<Archivey> createState() => _ArchiveyState();
}

class _ArchiveyState extends State<Archivey> {
  late StreamSubscription? _intentDataStreamSubscription;
  void goCallback(String sharedText){
    print('document add jh');
    goRouter.go('/document_add', extra: sharedText);
  }

  // void _handleSharingIntent(value) {
  //   if (value.isNotEmpty) {
  //     List<String> temp = [];
  //
  //     for (final e in value) {
  //       if (e.value is String) {
  //         temp.add(e.value!);
  //       }
  //     }
  //
  //     final sharedText = temp.join(' ');
  //     goRouter.go('/document_add', extra: sharedText);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    ///앱이 실행 중 일때 (백그라운드 포함) : getMediaStream()
    if (!kIsWeb){
      _intentDataStreamSubscription = SharingIntent.getMediaStream(goCallback);
      ///앱이 실행 중이 아닐 때: getInitialSharing()
      SharingIntent.getInitialSharing(goCallback);
    }else{
      print("xxxxxxx웹 환경: 공유 인텐트 기능 활성화xxxxxxx");
    }
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,

          ///스크롤 시 material 기본 색 없애기
          scrolledUnderElevation: 0,
        ),
        extensions: [AppColorScheme(), AppTextTheme()],
      ),
    );
  }
}
