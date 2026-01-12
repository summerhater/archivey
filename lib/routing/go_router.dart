// import 'package:archivey/ui/document/ai_summary_example.dart';
import 'package:archivey/ui/document/document_add_page.dart';
import 'package:archivey/ui/document/document_all_total_page.dart';
import 'package:archivey/ui/document/document_all_index_page.dart';
import 'package:archivey/ui/document/document_category_list_page.dart';
import 'package:archivey/ui/document/document_detail_page.dart';
import 'package:archivey/ui/auth/find_email_password_page.dart';
import 'package:archivey/ui/auth/auth_page.dart';
import 'package:archivey/ui/auth/sign_in_page.dart';
import 'package:archivey/ui/auth/signup_email_page.dart';
import 'package:archivey/ui/auth/signup_email_verify_page.dart';
import 'package:archivey/ui/auth/signup_password_page.dart';
import 'package:archivey/ui/auth/signup_success_page.dart';

import 'package:archivey/ui/onboarding/on_boarding_page.dart';
import 'package:archivey/ui/setting/settings_page.dart';
import 'package:go_router/go_router.dart';
import '../ui/document/document_shell_page.dart';
import '../ui/document/document_all_page.dart';
import 'package:flutter/material.dart';
import 'package:archivey/domain/model/document_model.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnBoardingPage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthPage(),
      redirect: (context, state) {},
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) => SignInPage(),
          routes: [
            GoRoute(
              path: 'find',
              builder: (context, state) => FindEmailPasswordPage(),
            ),
          ],
        ),
        GoRoute(
          path: 'signup-email',
          builder: (context, state) => SignupEmailPage(),
          routes: [
            GoRoute(
              path: 'signup-password',
              builder: (context, state) => SignupPasswordPage(),
              routes: [
                GoRoute(
                  path: 'signup-email-verify',
                  builder: (context, state) => SignupEmailVerifyPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'signup-success',
          builder: (context, state) => SignupSuccessPage(),
        ),
      ],
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return DocumentShellPage(contentPage: child);
      },
      routes: [
        /// all
        GoRoute(
          path: '/document_all_total',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DocumentAllPage(
              contentPage: DocumentAllTotalPage(),
            ),
          ),
          routes: [
            // GoRoute(
            //   path: 'detail',
            //   builder: (context, state) {
            //     final document = state.extra as DocumentModel;
            //     return DocumentDetailPage(document: document);
            //   },
            // ),
          ],
        ),
        GoRoute(
          path: '/document_all_index',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DocumentAllPage(
              contentPage: DocumentAllIndexPage(),
            ),
          ),
        ),

        ///사용자 설정 카테고리
        GoRoute(
          path: '/document_category/:name',
          pageBuilder: (context, state) {
            final name = state.pathParameters['name'] ?? 'ALL';
            return NoTransitionPage(
              child: DocumentCategoryListPage(categoryName: name),
            );
          },
        ),

        ///세팅 페이지
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: SettingsPage(),
            );
          },
        ),
      ],
    ),

    /// document 추가 페이지
    GoRoute(
      path: '/document_add',
      builder: (context, state) => DocumentAddPage(),
      // builder: (context, state) => AIValidationPage(),
    ),
  ],
);
