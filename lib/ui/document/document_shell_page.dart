import 'package:archivey/ui/document/widget/vertical_tab_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/color_scheme_extension.dart';
import '../../domain/model/document_model.dart';

class DocumentShellPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentShellPage({super.key, required this.contentPage});

  @override
  State<DocumentShellPage> createState() => DocumentShellPageState();
}

class DocumentShellPageState extends State<DocumentShellPage> {
  int selectedIndex = 0;

  int _getSelectedIndex(String location) {
    ///전체 카테고리 리스트를 가져오기 (ALL 포함)
    final categories = DocumentDummyData.getCategories();

    ///현재 경로에서 카테고리 이름 파라미터를 추출, 경로가 '/document_category/맛집' 이라면 '맛집'을 추출
    final Uri uri = Uri.parse(location);
    final String categoryName = uri.pathSegments.last;

    ///리스트에서 해당 이름이 몇 번째 인덱스인지 찾기
    final index = categories.indexOf(categoryName);

    return index;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAllTotalDetailPage = currentLocation.contains('all_total/detail');
    final categories = DocumentDummyData.getCategories();

    return Scaffold(
      backgroundColor: appColorScheme.primary,
      body: Row(
        children: [
          Expanded(
            child: widget.contentPage,
          ),
          if (!isAllTotalDetailPage)
            VerticalTabNavigation(
              selectedIndex: _getSelectedIndex(currentLocation),
              categories: DocumentDummyData.getCategories(),
              onTapChanged: (index) {
                if (index == -1) {
                  setState(() => selectedIndex = -1);
                  return;
                }

                if (index == 0) { /// ALL은 무조건 idx 0번
                  context.go('/document_all_total');
                } else {
                  final categories = DocumentDummyData.getCategories();
                  final selectedCategory = categories[index];
                  context.go('/document_category/$selectedCategory');
                }
              },
            ),
        ],
      ),
    );
  }
}
