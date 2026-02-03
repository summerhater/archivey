import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
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
  int _getSelectedIndex(String location, List<Map<String, String>> categories) {
    if (location.contains('document_all_total')) return 0;

    final Uri uri = Uri.parse(location);
    if (uri.pathSegments.isEmpty) return 0;

    /// URL의 마지막 부분(ID)을 가져와서 값이 일치하는 인덱스 찾기
    final String categoryId = uri.pathSegments.last;
    final index = categories.indexWhere((category) => category['id'] == categoryId);

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
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAllTotalDetailPage = currentLocation.contains('all_total/detail');

    return Scaffold(
      backgroundColor: appColorScheme.primary,
      body: Row(
        children: [
          Expanded(
            child: widget.contentPage,
          ),
          if (!isAllTotalDetailPage)
            Consumer<CategoryViewModel>(
                builder: (context, vm, _) {
                  final displayCategories = [
                    {'id': 'ALL', 'name': '전체'},
                    ...vm.rootCategories.map((c) => {'id': c.categoryId, 'name': c.categoryName}),
                  ];

                  return VerticalTabNavigation(
                    categories: displayCategories.map((e) => e['name']!).toList(),
                    selectedIndex: _getSelectedIndex(currentLocation, displayCategories),
                    onTapChanged: (index) {
                      final currentIdx = _getSelectedIndex(currentLocation, displayCategories);

                      if (currentIdx == index) {
                        context.read<DocViewModel>().scrollToTop();
                        return;
                      }

                      if (index == -1) {
                        setState(() => selectedIndex = -1);
                        return;
                      }

                      final selected = displayCategories[index];
                      final String id = selected['id']!;
                      final String name = selected['name']!;

                      if (selected['id'] == 'ALL') {
                        context.go('/document_all_total');
                      } else {
                        /// ID를 경로에, 이름을 쿼리에 넣고 이동
                        context.go('/document_category/$id?name=$name');
                      }
                    },
                    isCategoryExist: vm.categories.isEmpty ? false : true,
                  );
                }
            ),
        ],
      ),
    );
  }
}
