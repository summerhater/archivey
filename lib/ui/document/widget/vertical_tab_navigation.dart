import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../config/text_theme_extension.dart';

class VerticalTabNavigation extends StatelessWidget {
  final ValueChanged<int> onTapChanged;
  final int? selectedIndex;
  final List<String> categories;

  const VerticalTabNavigation({
    super.key,
    required this.onTapChanged,
    required this.selectedIndex,
    required this.categories,
  });

  ///탭 하나가 차지할 고정 높이
  static const double tabHeight = 170.0;

  ///탭끼리 겹칠 간격
  static const double overlap = 20.0;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final String currentLocation = GoRouterState.of(context).uri.toString();
    final bool isOnAllPage = currentLocation.contains('all_total') || currentLocation.contains('all_index');
    final bool isOnSettingPage = currentLocation.contains('settings');
    return SizedBox(
      width: 32,
      child: Container(
        ///all탭 선택 시 상단 패딩 배경 색
        color: isOnAllPage
            ? appColorScheme.primary
            : appColorScheme.primaryStrong,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: appColorScheme.primary,
                      width: .5,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  primary: false,
                  padding: EdgeInsets.only(
                    ///상단 상태바 높이만큼 패딩주기
                    top: 30,
                  ),
                  child: Container(
                    color: appColorScheme.primaryStrong,

                    ///탭 개수에 따른 전체 길이 설정
                    height: (categories.length * tabHeight) - 40,
                    child: Stack(children: _buildTopFirstStackedTabs(context, isOnAllPage)),
                  ),
                ),
              ),
            ),

            /// 하단 고정 설정 영역(settings, add button)
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appColorScheme.primary,
                    width: .5,
                  ),
                  right: BorderSide(
                    color: appColorScheme.primary,
                    width: .5,
                  ),
                ),
                color: appColorScheme.primaryStrong,
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    context.push('/document_add');
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.add,
                    color: appColorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                top: 20,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appColorScheme.primary,
                    width: .5,
                  ),
                  right: BorderSide(
                    color: appColorScheme.primary,
                    width: .5,
                  ),
                  left: isOnSettingPage ? BorderSide(
                    color: appColorScheme.primaryStrong,
                    width: .3,
                  ) : BorderSide.none,
                ),
                color: isOnSettingPage ? appColorScheme.primary : appColorScheme.primaryStrong,
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    context.go('/settings');
                    // print('here');
                    onTapChanged(-1);
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.settings_outlined,
                    color: isOnSettingPage ? appColorScheme.primaryStrong : appColorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopFirstStackedTabs(
    context, isOnAllPage,
  ) {
    return categories
        .asMap()
        .entries
        .map((entry) {
          int idx = entry.key;
          bool isSelected = (idx == 0) ? isOnAllPage : (selectedIndex == idx);

          return Positioned(
            ///아래로 갈수록 각 탭의 top 값 커지게 해서 탭이 겹치게끔
            top: idx * (tabHeight - overlap),
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => onTapChanged(idx),
              child: _buildTabItem(context, entry.value, isSelected),
            ),
          );
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _buildTabItem(BuildContext context, String title, bool isSelected) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      height: tabHeight,
      decoration: BoxDecoration(
        color: isSelected
            ? appColorScheme.primary
            : appColorScheme.primaryStrong,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(color: appColorScheme.primary, width: .5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              width: 85,
              child: Text(
                title,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appTextTheme.bodySmall.copyWith(
                  color: isSelected
                      ? appColorScheme.textDark
                      : appColorScheme.textLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
