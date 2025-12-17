import 'package:archivey/ui/document/document_detail_page.dart';
import 'package:archivey/ui/document/document_index_page.dart';
import 'package:archivey/ui/document/document_list_page.dart';
import 'package:archivey/ui/login/login_page.dart';
import 'package:archivey/ui/login/signup_email_page.dart';
import 'package:archivey/ui/login/signup_email_verify_page.dart';
import 'package:archivey/ui/login/signup_password_page.dart';
import 'package:archivey/ui/login/signup_success_page.dart';
import 'package:archivey/ui/onboarding/on_boarding_page.dart';
import 'package:archivey/ui/setting/settings_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnBoardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      routes: [
        GoRoute(
          path: 'signup-email',
          builder: (context, state) => SignupEmailPage(),
          routes: [
            GoRoute(
              path: 'signup-email-verify',
              builder: (context, state) => SignupEmailVerifyPage(),
              routes:[
                GoRoute(
                  path: 'signup-password',
                  builder: (context, state) => SignupPasswordPage(),
                  routes: [
                    GoRoute(
                      path: 'signup-success',
                      builder: (context, state) => SignupSuccessPage(),
                    )
                  ],
                )
              ]
            )
          ]
        )
      ]
    ),
    GoRoute(
      path: '/document-index',
      builder: (context, state) => DocumentIndexPage(),
      routes: [
        GoRoute(
          path: 'list',
          builder: (context, state) => DocumentListPage(category: state.pathParameters['category']),
          routes:[
            GoRoute(
              path: 'detail',
              builder: (context, state) => DocumentDetailPage(docId: state.pathParameters['docId']),
            )
          ]
        )
      ]
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    )
  ]
);