import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import 'bottom_sheet_category_add_edit_widget.dart';
import 'bottom_sheet_more_action_widget.dart';

class DocumentListHeaderWidget extends StatefulWidget {
  final bool isOnAllPage;
  final CategoryModel? rootCategory;
  final int documentCount;
  final Function(String? subCategoryId)? selectedSubCategory;
  final bool isLatest;
  final VoidCallback onDateSortPressed;

  const DocumentListHeaderWidget({
    super.key,
    required this.isOnAllPage,
    required this.rootCategory,
    required this.documentCount,
    this.selectedSubCategory,
    required this.isLatest,
    required this.onDateSortPressed,
  });

  @override
  State<DocumentListHeaderWidget> createState() =>
      _DocumentListHeaderWidgetState();
}

class _DocumentListHeaderWidgetState extends State<DocumentListHeaderWidget> {
  int _selectedIndex = 0;
  bool _isBookmarkSelected = false;

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
    final isIndexSelected = currentLocation.contains('_index');
    final isTotalSelected = currentLocation.contains('_total');

    String? _searchValue;
    final isSelected;

    return Consumer<CategoryViewModel>(
      builder: (context, categoryVM, _) {
        final roots = categoryVM.rootCategories;

        if (roots.isEmpty) {
          return const SizedBox.shrink();
        }

        final CategoryModel currentRoot =
        widget.isOnAllPage
            ? roots.first
            : roots.firstWhere(
              (c) => c.categoryName == widget.rootCategory!.categoryName,
          orElse: () => roots.first,
        );

        final List<CategoryModel> subCategories =
        widget.isOnAllPage
            ? const []
            : categoryVM.getSubCategories(currentRoot.categoryId);

        return Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: widget.isOnAllPage
                    ? Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/document_all_index');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.0, bottom: 2.5),
                        child: Text(
                          "Index",
                          style: appTextTheme.headlineSmallEn.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isIndexSelected
                                ? appColorScheme.textDark
                                : appColorScheme.textLight,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: .5,
                      height: 15,
                      color: appColorScheme.textLight,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/document_all_total');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 14,
                        ),
                        child: Text(
                          "전체",
                          style: appTextTheme.headlineSmallKo.copyWith(
                            color: isTotalSelected
                                ? appColorScheme.textDark
                                : appColorScheme.textLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.5),
                      child: Text(
                        currentRoot.categoryName,
                        textAlign: TextAlign.left,
                        style: appTextTheme.headlineSmallKo.copyWith(
                          color: appColorScheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          
              /// subCategories 칩 버튼 선택
              if (!widget.isOnAllPage)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 40, // ChoiceChip 높이에 맞게
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: subCategories.length + 2,
                      itemBuilder: (context, index) {
                        final bool isSelected = _selectedIndex == index;
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
                              selected: _selectedIndex == 0,
                              onSelected: (val) {
                                setState(() => _selectedIndex = 0);
                                widget.selectedSubCategory!(null); /// '전체' 선택 시 null 전달
                              },
                            ),
                          );
                        } else if (index <= subCategories.length) {
                          final sub = subCategories[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onLongPress: () {
                                showModalBottomSheet<String>(
                                  isScrollControlled: true,
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (_) => BottomSheetMoreActionWidget(
                                    isSubCategory: true,
                                    typeSettingMode: TypeSettingMode.category,
                                    originalCategoryModel: sub,
                                  ),
                                );
                              },
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
                                selected: _selectedIndex == index,
                                onSelected: (val) {
                                  setState(() => _selectedIndex = index);
                                  widget.selectedSubCategory!(sub.categoryId);
                                },
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RawChip(
                              backgroundColor: appColorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  color: isSelected
                                      ? appColorScheme.primaryStrong
                                      : appColorScheme.strokeLight,
                                ),
                              ),
                              onSelected: (val) async {
                                final newCategoryName = await showModalBottomSheet<String>(
                                  isScrollControlled: true,
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (_) => BottomSheetCategoryAddEditWidget(
                                    categorySettingMode: CategorySettingMode.subAdd,
                                    parentCategoryId: widget.rootCategory?.categoryId,
                                  ),
                                );
                                if (newCategoryName != null) {
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
                              },
                              label: Icon(Icons.add, size: 18),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
          
              SizedBox(
                height: 4,
              ),
          
              /// 검색창
              if (!isIndexSelected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      // _searchValue = value;
                      Provider.of<DocViewModel>(context, listen: false).search(keyword: value,);
                    },
                    cursorColor: appColorScheme.categoryTagBg,
                    cursorWidth: 1.0,
                    cursorHeight: 18,
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
          
              /// 수집물 개수 및 정렬 버튼 영역
              if (!isIndexSelected)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,10,20,14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '수집물',
                              style: appTextTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: appColorScheme.textLight,
                              ),
                            ),
                            TextSpan(
                              text: widget.documentCount.toString(),
                              style: appTextTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: appColorScheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ///북마크순 버튼
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isBookmarkSelected = !_isBookmarkSelected; /// 북마크 활성화
                                // _isLatest = true;
                              });
                            },
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: Colors.transparent,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              '북마크순',
                              style: appTextTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _isBookmarkSelected
                                    ? appColorScheme.textDark
                                    : appColorScheme.textLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ///최신순 / 과거순 버튼
                          TextButton(
                            onPressed: () {
                              widget.onDateSortPressed();
                              setState(() {
                                if (_isBookmarkSelected) {
                                  _isBookmarkSelected = false;
                                }
                              });

                            },
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: Colors.transparent,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.isLatest ? '최신순' : '과거순',
                                  style: appTextTheme.labelLarge.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: !_isBookmarkSelected
                                        ? appColorScheme.textDark
                                        : appColorScheme.textLight,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                SvgPicture.asset(
                                  'assets/icons/sort.svg',
                                  width: 13,
                                  height: 13,
                                  colorFilter: ColorFilter.mode(
                                    !_isBookmarkSelected
                                        ? appColorScheme.textDark
                                        : appColorScheme.textLight,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
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
}
