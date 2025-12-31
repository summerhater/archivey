import 'dart:async';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/firebase_options.dart';
import 'package:archivey/routing/go_router.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize the Gemini Developer API backend service
  // Create a `GenerativeModel` instance with a model that supports your use case
  final model =
  FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

// Provide a prompt that contains text
//   final prompt = [Content.text('Write a story about a magic backpack.')];

// To generate text output, call generateContent with the text input
//   final response = await model.generateContent(prompt);
//   print(response.text);
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

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;

  @override
  void initState() {
    initSharingListener();

    super.initState();
  }

  void initSharingListener() {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedFile> value) {
            setState(() {
              list = value;
            });
            if (kDebugMode) {
              print(
                " Shared: getMediaStream ${value.map((f) => f.value).join(",")}",
              );
            }
          },
          onError: (err) {
            if (kDebugMode) {
              print("Shared: getIntentDataStream error: $err");
            }
          },
        );

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((
      List<SharedFile> value,
    ) {
      if (kDebugMode) {
        print(
          "Shared: getInitialMedia => ${value.map((f) => f.value).join(",")}",
        );
      }
      setState(() {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Text('Sharing data: \n${list?.join("\n\n")}\n'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
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
