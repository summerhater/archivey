import 'package:archivey/domain/model/document_model.dart';
// import 'package:archivey/ui/document/ai_summary_example.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
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
import 'package:provider/provider.dart';
import '../ui/document/document_shell_page.dart';
import '../ui/document/document_all_page.dart';
import 'package:flutter/material.dart';

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
      redirect: (context, state) {
        if(Provider.of<AuthViewModel>(context, listen: false).uid.isNotEmpty) {
          return '/document_all_total';
        }
      },
      builder: (context, state) => AuthPage(),
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
            GoRoute(
              path: 'detail',
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
          path: '/document_category/:id', // 1. 경로 파라미터를 id로 변경
          pageBuilder: (context, state) {
            // 2. 경로에서 ID 추출
            final id = state.pathParameters['id'] ?? 'ALL';

            // 3. 쿼리 스트링에서 name 추출 (?name=전체)
            // 이름이 없을 경우를 대비해 기본값을 'ALL' 혹은 적절한 이름으로 설정합니다.
            final name = state.uri.queryParameters['name'] ?? 'ALL';

            return NoTransitionPage(
              child: DocumentCategoryListPage(
                categoryId: id,      // 새로 추가한 필드
                categoryName: name,  // 기존 필드
              ),
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
      builder: (context, state) {
        final sharedText = state.extra as String?;
        return DocumentAddPage(sharedText: sharedText);
      },
      // builder: (context, state) => AIValidationPage(),
    ),
  ],
);
