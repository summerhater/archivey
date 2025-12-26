import 'package:archivey/ui/document/widget/vertical_tab_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/color_scheme_extension.dart';
import '../../domain/model/document_model.dart';

class DocumentShellPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentShellPage({super.key, required this.contentPage});

  @override
  State<DocumentShellPage> createState() => _DocumentShellPageState();
}

class _DocumentShellPageState extends State<DocumentShellPage> {
  int selectedIndex = 0;

  void _onTapChanged(int idx) {
    setState(() {
      selectedIndex = idx;
    });

    switch (idx) {
      case 0:
        context.go('/document_all_total');
        break;

      case 1:
        context.go('/document/취업');
        break;

      case 2:
        context.go('/document/recipe');
        break;
    }
  }

  int _getSelectedIndex(String location) {
    // 1. 전체 카테고리 리스트를 가져옵니다 (ALL 포함)
    final categories = DocumentDummyData.getCategories();

    // 2. 현재 경로에서 카테고리 이름 파라미터를 추출합니다.
    // 경로가 '/document_category/맛집' 이라면 '맛집'을 추출
    final Uri uri = Uri.parse(location);
    final String categoryName = uri.pathSegments.last;

    // 3. 리스트에서 해당 이름이 몇 번째 인덱스인지 찾습니다.
    final index = categories.indexOf(categoryName);

    // 4. 만약 못 찾으면 기본값인 0(ALL)을 반환합니다.
    return index != -1 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final String currentPath = GoRouterState.of(context).uri.toString();
    final categories = DocumentDummyData.getCategories();

    return Scaffold(
      backgroundColor: appColorScheme.primaryLight,
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              primary: true,
              backgroundColor: Colors.transparent,
              body: widget.contentPage,
            ),
          ),
          // VerticalTabNavigation(
          //   onTapChanged: _onTapChanged,
          //   selectedIndex: selectedIndex,
          // ),
          // VerticalTabNavigation을 사용하는 부모 위젯 (예: DocumentShellPage 혹은 DocumentAllPage)
          VerticalTabNavigation(
            selectedIndex: _getSelectedIndex(
              currentPath,
            ), // 현재 경로에 따른 인덱스 계산 함수 필요
            categories: DocumentDummyData.getCategories(),
            onTapChanged: (index) {
              final selectedCategory = categories[index];
              // 해당 카테고리 경로로 이동
              context.go('/document_category/$selectedCategory');
            },
          ),
        ],
      ),
    );
  }
}
