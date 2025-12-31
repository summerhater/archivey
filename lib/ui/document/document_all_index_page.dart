import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import '../../domain/model/document_model.dart';
import 'document_shell_page.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:archivey/ui/document/widget/document_all_index_post_count_widget.dart';


class DocumentAllIndexPage extends StatefulWidget {
  const DocumentAllIndexPage({super.key});
  @override
  State<DocumentAllIndexPage> createState() => _DocumentAllIndexPageState();
}

class _DocumentAllIndexPageState extends State<DocumentAllIndexPage> {
  List<String> _displayCategories = []; ///all을 제외한 나머지 편집 가능한 카테고리

  Future<void> _loadCategories() async {
    final categories = await DocumentDummyData.getManageableCategories();

    setState(() {
      _displayCategories = categories;
    });
  }

  Future<void> _onAddCategoryPressed() async {
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final newCategoryName = await showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      builder: (_) => BottomSheetCategoryAddEditWidget(
        categorySettingMode: CategorySettingMode.add,
      ),
    );

    if (!mounted) return;

    if (newCategoryName != null && newCategoryName.isNotEmpty) {
      context.showAppSnackBar(
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '\'$newCategoryName\'',
                style: appTextTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' 카테고리가 추가 되었습니다 ☻'),
            ],
            style: appTextTheme.bodySmall.copyWith(
              color: appColorScheme.primary,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: SizedBox(
        height: 43,
        child: FloatingActionButton.extended(
          onPressed: _onAddCategoryPressed,
          backgroundColor: appColorScheme.primaryStrong,
          foregroundColor: appColorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          label: Text(
            '새 카테고리 추가',
            style: appTextTheme.bodySmall.copyWith(height: 1.2),
          ),
          icon: SvgPicture.asset(
            'assets/images/logo_variation_plus.svg',
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              appColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ReorderableListView.builder(
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double elevation = Curves.easeInOut.transform(animation.value) * 8;
                    return Material(
                      elevation: elevation,
                      shadowColor: appColorScheme.primaryStrong.withValues(alpha:0.3),
                      color: appColorScheme.documentDetailBg.withValues(alpha:0.9),
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              itemCount: _displayCategories.length,
              onReorder: (oldIndex, newIndex) async {
                var updated = List<String>.from(_displayCategories);
                updated = await DocumentDummyData.getManageableCategories();
                setState(() {
                  ///카테고리 리스트 아이템 롱탭 - 드래그앤드랍으로 순서 변경하기
                  ///1. 전역 데이터 순서 변경 (임시로 static 선언해 놓음)
                  DocumentDummyData.reorderCategories(oldIndex, newIndex);
                  ///2. 현재 화면 리스트 갱신
                  _displayCategories = updated;
                });

                ///contentpage가 gorouter에서 주입되고 있어서 vertical navigation bar 감싸고 있는 DocumentShellPage에 콜백 주기가 애매해져버렸다.
                ///그래서 vertical navigation bar 감싸고 있는 DocumentShellPage에 강제로 setstate..
                ///나중에 provider 상태관리 라이브러리 쓰면 이렇게 강제 주입 안해도 되는건가?
                context.findAncestorStateOfType<DocumentShellPageState>()?.setState(() {});
              },
              itemBuilder: (context, index) {
                final category = _displayCategories[index];

                return Container(
                  ///ReorderableListView 쓸라면 각 아이템에 반드시 고유한 Key가 필요
                  key: ValueKey(category),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: appColorScheme.strokeLight,
                        width: .5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: appTextTheme.headlineSmallKo.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Row(
                          children: [
                            const DocumentAllIndexPostCountWidget(),
                            const SizedBox(width: 10),
                            const MoreIconWidget(
                              moreIconSettingMode: MoreIconSettingMode.category,
                            ),
                            const SizedBox(width: 8),
                            /// 아이템을 꾹 누르지 않아도 핸들 아이콘으로 드래그 가능하게 함
                            Icon(
                              Icons.menu,
                              color: appColorScheme.textLight,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
