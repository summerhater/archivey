import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/firebase_options.dart';
import 'package:archivey/routing/go_router.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<FirebaseAppUserService>(
          create: (_) => FirebaseAppUserService(),
        ),

        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<FirebaseAuthService>(),
            context.read<FirebaseAppUserService>(),
          ),
        ),
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
  final _intentDataStreamSubscription = FlutterSharingIntent.instance; // 파일 공유 테스트
  List<SharedFile>? list;

  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription.getInitialSharing().then((value) {
      if (value.isNotEmpty) {
        debugPrint('Initial share: $value');
      }
    });

    _intentDataStreamSubscription.getMediaStream().listen((value) {
      if (value.isNotEmpty) {
        debugPrint('Incoming share: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        extensions: [
          AppTextTheme(),
          AppColorScheme(),
        ],
      ),
    );
  }
}
