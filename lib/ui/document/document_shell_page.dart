import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:archivey/ui/document/widget/vertical_tab_navigation.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  int _getSelectedIndex(String location, List<String> categories) {
    // 전체보기 페이지인 경우
    if (location.contains('document_all_total')) return 0;

    final Uri uri = Uri.parse(location);
    if (uri.pathSegments.isEmpty) return 0;

    final String categoryName = uri.pathSegments.last;

    // 인자로 받은 실제 카테고리 리스트에서 인덱스 검색
    final index = categories.indexOf(categoryName);

    return index != -1 ? index : 0;
  }

  @override
  void initState() {
    Provider.of<CategoryViewModel>(context, listen: false).readCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAllTotalDetailPage = currentLocation.contains('all_total/detail');
    final categoryVM = context.watch<CategoryViewModel>();

    final List<String> categoryNames = [
      'ALL',
      ...categoryVM.rootCategories.map((e) => e.categoryName)
    ];

    return Scaffold(
      backgroundColor: appColorScheme.primary,
      body: Row(
        children: [
          Expanded(
            child: widget.contentPage,
          ),
          if (!isAllTotalDetailPage)
            VerticalTabNavigation(
              selectedIndex: _getSelectedIndex(currentLocation, categoryNames),
              categories: categoryNames,
              onTapChanged: (index) {
                if (index == -1) {
                  setState(() => selectedIndex = -1);
                  return;
                }

                if (index == 0) { /// ALL은 무조건 idx 0번
                  context.go('/document_all_total');
                } else {
                  final selectedCategory = categoryNames[index];
                  context.go('/document_category/$selectedCategory');
                }
              },
            ),
        ],
      ),
    );
  }
}
