import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentListHeaderWidget extends StatefulWidget {
  final bool isOnAllPage;

  const DocumentListHeaderWidget({
    super.key,
    required this.isOnAllPage,
  });

  @override
  State<DocumentListHeaderWidget> createState() =>
      _DocumentListHeaderWidgetState();
}

class _DocumentListHeaderWidgetState extends State<DocumentListHeaderWidget> {
  int? _selectedIndex = 0;
  bool _isBookmarkSelected = false;
  bool _isLatest = true; /// 북마크순 선택 여부

  List<String> subCategories = [
    '전체',
    'sub1',
    'sub2',
    'sub3',
    'sub4',
    'sub5',
    'sub6',
  ];

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isIndexSelected = currentLocation.contains('_index');
    final isTotalSelected = currentLocation.contains('_total');

    String? _searchValue;
    final isSelected;

    return Column(
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
                        "카테고리 이름",
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
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final bool isSelected = _selectedIndex == index;

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
                        subCategories[index],
                        style: appTextTheme.bodySmall.copyWith(
                          color: isSelected
                              ? appColorScheme.primary
                              : appColorScheme.primaryStrong,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedIndex = selected ? index : null;
                        });
                      },
                    ),
                  );
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
              _searchValue = value;
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
                      text: ' 365',
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
                        _isLatest = true;
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
                      setState(() {
                        // print('1. _isLatest : $_isLatest');
                        if (_isBookmarkSelected) {
                          _isBookmarkSelected = false;
                          _isLatest = _isLatest;
                        } else {
                          _isLatest = !_isLatest;
                        }
                        // print('2. _isLatest : $_isLatest');
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
                          _isLatest ? '최신순' : '과거순',
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
    );
  }
}
