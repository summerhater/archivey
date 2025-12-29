import 'package:archivey/ui/document/document_add_page.dart';
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
            GoRoute(
              path: 'detail',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final document = state.extra as DocumentModel;
                return DocumentDetailPage(document: document);
              },
            ),
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
              child: DocumentCategoryPageListPage(category: name),
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
    ),
  ],
);
