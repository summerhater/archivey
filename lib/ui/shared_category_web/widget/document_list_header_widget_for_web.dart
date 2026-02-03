import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/shared_category_web/view_model/shared_category_web_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentListHeaderWidgetForWeb extends StatefulWidget {
  final CategoryModel? rootCategory;
  final int documentCount;
  final Function(String? subCategoryId)? selectedSubCategory;
  final bool isLatest;
  final VoidCallback onDateSortPressed;
  final bool isBookmarkSelected;
  final VoidCallback onBookmarkSortPressed;

  const DocumentListHeaderWidgetForWeb({
    super.key,
    required this.rootCategory,
    required this.documentCount,
    this.selectedSubCategory,
    required this.isLatest,
    required this.onDateSortPressed,
    required this.isBookmarkSelected,
    required this.onBookmarkSortPressed,
  });

  @override
  State<DocumentListHeaderWidgetForWeb> createState() =>
      _DocumentListHeaderWidgetForWebState();
}

class _DocumentListHeaderWidgetForWebState extends State<DocumentListHeaderWidgetForWeb> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Consumer<SharedCategoryWebViewModel>(
        builder: (context, vm, _) {
          final currentRoot = vm.category;
          final subCategories = vm.subCategories;

          return Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///카테고리 이름
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    currentRoot?.categoryName ?? '카테고리 정보 없음',
                    textAlign: TextAlign.left,
                    style: appTextTheme.headlineSmallKo.copyWith(
                      color: appColorScheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ///소분류(Sub-Categories) 필터 칩 영역
                if (subCategories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        /// '전체' 버튼 + 서브 카테고리들
                        itemCount: subCategories.length + 1,
                        itemBuilder: (context, index) {
                          final bool isSelected = _selectedIndex == index;

                          /// '전체' 칩
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                showCheckmark: false,
                                backgroundColor: appColorScheme.primary,
                                selectedColor: appColorScheme.primaryStrong,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: isSelected
                                        ? appColorScheme.primaryStrong
                                        : appColorScheme.strokeLight,
                                  ),
                                ),
                                label: Text(
                                  '전체',
                                  style: appTextTheme.bodySmall.copyWith(
                                    color: isSelected
                                        ? appColorScheme.primary
                                        : appColorScheme.primaryStrong,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (val) {
                                  setState(() => _selectedIndex = 0);
                                  widget.selectedSubCategory?.call(null);
                                },
                              ),
                            );
                          }

                          /// 서브 카테고리 칩
                          else {
                            final sub = subCategories[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                showCheckmark: false,
                                backgroundColor: appColorScheme.primary,
                                selectedColor: appColorScheme.primaryStrong,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: isSelected
                                        ? appColorScheme.primaryStrong
                                        : appColorScheme.strokeLight,
                                  ),
                                ),
                                label: Text(
                                  sub.categoryName,
                                  style: appTextTheme.bodySmall.copyWith(
                                    color: isSelected
                                        ? appColorScheme.primary
                                        : appColorScheme.primaryStrong,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (val) {
                                  setState(() => _selectedIndex = index);
                                  widget.selectedSubCategory?.call(sub.categoryId);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  ///검색창
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: TextField(
                      onChanged: (value) {
                        vm.search(value);
                      },
                      cursorColor: appColorScheme.categoryTagBg,
                      cursorWidth: 1.0,
                      cursorHeight: 18,
                      style: appTextTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: appColorScheme.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: '키워드 입력',
                        hintStyle: appTextTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appColorScheme.textLight,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: appColorScheme.textLight,
                        ),
                        filled: true,
                        fillColor: appColorScheme.searchBackground,
                        border: OutlineInputBorder(
                          /// 기본 테두리 (비활성화 시)
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),

                /// 수집물 개수 및 정렬 버튼
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '수집물 ',
                              style: appTextTheme.labelLarge.copyWith(
                                color: appColorScheme.textLight,
                              ),
                            ),
                            TextSpan(
                              text: widget.documentCount.toString(),
                              style: appTextTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appColorScheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // 북마크 정렬
                          _buildSortButton(
                            label: '북마크',
                            isSelected: widget.isBookmarkSelected,
                            onPressed: widget.onBookmarkSortPressed,
                            appTextTheme: appTextTheme,
                            appColorScheme: appColorScheme,
                          ),
                          const SizedBox(width: 15),
                          // 날짜 정렬
                          _buildSortButton(
                            label: widget.isLatest ? '최신순' : '등록순',
                            isSelected: !widget.isBookmarkSelected,
                            onPressed: widget.onDateSortPressed,
                            appTextTheme: appTextTheme,
                            appColorScheme: appColorScheme,
                            iconPath: '../../../../../../assets/icons/sort.svg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildSortButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
    required AppTextTheme appTextTheme,
    required AppColorScheme appColorScheme,
    String? iconPath,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: appTextTheme.labelLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? appColorScheme.textDark : appColorScheme.textLight,
            ),
          ),
          if (iconPath != null) ...[
            const SizedBox(width: 4),
            SvgPicture.asset(
              iconPath,
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                isSelected ? appColorScheme.textDark : appColorScheme.textLight,
                BlendMode.srcIn,
              ),
            ),
          ]
        ],
      ),
    );
  }
}