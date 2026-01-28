import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/utils/kakao_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/model/document_model.dart';
import 'document_shell_page.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:archivey/ui/document/widget/document_all_index_post_count_widget.dart';

class DocumentAllIndexPage extends StatefulWidget {
  const DocumentAllIndexPage({super.key});
  @override
  State<DocumentAllIndexPage> createState() => _DocumentAllIndexPageState();
}

class _DocumentAllIndexPageState extends State<DocumentAllIndexPage> {
  Future<void> _onAddCategoryPressed() async {
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
      context.showAppMessageSnackBar('$newCategoryName 카테고리가 추가 완료 되었습니다 ☻');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Stack(
      children: [
        Consumer<CategoryViewModel>(
            builder: (context, vm, _) {
              var rootCategories = vm.rootCategories;
              if (rootCategories.isEmpty) {
                return Center(
                  child: SizedBox(
                    child: SvgPicture.asset(
                        'assets/images/empty_state_no_category.svg',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                );
              }
              if (vm.errorMessage != null) {
                context.showAppMessageSnackBar('에러 발생 : ${vm.errorMessage!}');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ReorderableListView.builder(
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            final double elevation =
                                Curves.easeInOut.transform(animation.value) * 8;
                            return Material(
                              elevation: elevation,
                              shadowColor: appColorScheme.primaryStrong
                                  .withValues(alpha: 0.3),
                              color: appColorScheme.documentDetailBg.withValues(
                                alpha: 0.9,
                              ),
                              child: child,
                            );
                          },
                          child: child,
                        );
                      },
                      itemCount: rootCategories.length,
                      onReorder: (oldIndex, newIndex) async {
                        vm.updateReorderCategories(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final category = rootCategories[index];
                        final documentCount = vm.getRootCategoryDocCount(category.categoryId);
                        return Container(
                          ///ReorderableListView 쓸라면 각 아이템에 반드시 고유한 Key가 필요
                          key: ValueKey(category.categoryName),
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
                                Expanded(
                                  child: Text(
                                    category.categoryName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTextTheme.headlineSmallKo.copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Row(
                                  children: [
                                    DocumentAllIndexDocumentCountWidget(documentCount: documentCount),
                                    const SizedBox(width: 10),
                                    MoreIconWidget(
                                      moreIconSettingMode:
                                          MoreIconSettingMode.category,
                                      originalCategoryModel: category,
                                      onDeleteConfirmed: () {
                                        vm.deleteCategory(category.categoryId);
                                      },
                                      onCopyLinkConfirmed : () async {
                                        final String? shareCategoryURL = await vm.createSharedCategoryLink(category.categoryId);
                                        if (shareCategoryURL != null && context.mounted) {
                                          await Clipboard.setData(ClipboardData(text: await shareCategoryURL));
                                          context.showAppMessageSnackBar('카테고리 링크가 복사되었습니다. ☻');
                                        } else {
                                          if (context.mounted) {
                                            context.showAppMessageSnackBar('카테고리 공유 링크 생성 중 오류가 발생했습니다.');
                                          }
                                        }
                                      },
                                      onShareKakaoConfirmed: () async {
                                        final String? shareCategoryURL = await vm.createSharedCategoryLink(category.categoryId);
                                        if (shareCategoryURL != null) {
                                          kakaoShareCategoryURL(shareCategoryURL, category);
                                        } else {
                                          if (context.mounted) {
                                            context.showAppMessageSnackBar('카테고리 카카오톡 공유 중 오류가 발생했습니다.');
                                          }
                                        }
                                      },
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
              );
            },
          ),
        Positioned(
          right: 16,
          bottom: 24,
          child: SizedBox(
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
        ),
      ],
    );
  }
}
