import 'package:archivey/ui/document/document_all_total_page.dart';
import 'package:archivey/ui/document/document_all_index_page.dart';
import 'package:archivey/ui/document/document_category_list_page.dart';
import 'package:archivey/ui/document/document_detail_page.dart';
import 'package:archivey/ui/login/login_page.dart';
import 'package:archivey/ui/login/signup_email_page.dart';
import 'package:archivey/ui/login/signup_email_verify_page.dart';
import 'package:archivey/ui/login/signup_password_page.dart';
import 'package:archivey/ui/login/signup_success_page.dart';
import 'package:archivey/ui/onboarding/on_boarding_page.dart';
import 'package:archivey/ui/setting/settings_page.dart';
import 'package:go_router/go_router.dart';

import '../domain/model/document_model.dart';
import '../ui/document/document_shell_page.dart';
import '../ui/document/document_all_page.dart';
import 'package:flutter/material.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/document_all_total',
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
              routes: [
                GoRoute(
                  path: 'signup-password',
                  builder: (context, state) => SignupPasswordPage(),
                  routes: [
                    GoRoute(
                      path: 'signup-success',
                      builder: (context, state) => SignupSuccessPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    ///document가 반복되서 document는 페이지가 없고 ShellRoute가 페이지를 감싸는 역할로 구현하려 했으나 구현한 코드가 없는
    ///구색용 페이지로써 임의로 /document 지정 불가 -> shellRoute 작동안함 -> 그냥 모든 하위 경로를 절대 경로로 변경
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
          // routes: [
          //   GoRoute(
          //     path: 'detail',
          //     builder: (context, state) {
          //       final document = state.extra as DocumentModel;
          //       return DocumentDetailPage(document: document);
          //     },
          //   ),
          // ],
        ),
        GoRoute(
          path: '/document_all_index',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DocumentAllPage(
              contentPage: DocumentAllIndexPage(),
            ),
          ),
        ),

        /// others
        GoRoute(
          path: '/document/취업',
          builder: (context, state) => DocumentCategoryPageListPage(
            category: '취업',
          ),
        ),
        GoRoute(
          path: '/document/recipe',
          builder: (context, state) => DocumentCategoryPageListPage(
            category: '레시피',
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
    GoRoute(
      path: '/document_all_total/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final document = state.extra as DocumentModel;
        return DocumentDetailPage(document: document);
      },
    ),
  ],
);
