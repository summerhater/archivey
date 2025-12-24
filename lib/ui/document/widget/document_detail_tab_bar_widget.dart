import 'package:flutter/material.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentDetailTabBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<String> tabs;

  const DocumentDetailTabBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  /// 탭 하나가 차지할 고정 높이
  static const double tabHeight = 50.0;
  static const double tabWidth = 110.0;

  /// 탭끼리 겹칠 간격
  static const double overlap = 20.0;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: Colors.red,
        height: 50,
        child: Stack(
          children: _buildStackedTabs(context, appColorScheme, appTextTheme),
        ),
      ),
    );
  }

  List<Widget> _buildStackedTabs(
      BuildContext context, AppColorScheme appColorScheme, AppTextTheme appTextTheme) {
    return tabs.asMap().entries.map((entry) {
      int idx = entry.key;
      bool isSelected = selectedIndex == idx;

      return Positioned(
        /// 아래로 갈수록 각 탭의 top 값 커지게
        left: idx == 0 ? 0 : idx * (tabWidth - overlap),
        child: GestureDetector(
          onTap: () => onTabChanged(idx),
          child: _buildTabItem(
            context,
            entry.value,
            isSelected,
            appColorScheme,
            appTextTheme
          ),
        ),
      );
    })
        .toList()
        .reversed
        .toList();
  }

  Widget _buildTabItem(
      BuildContext context,
      String title,
      bool isSelected,
      AppColorScheme appColorScheme,
      AppTextTheme appTextTheme,
      ) {
    return Container(
      height: tabHeight,
      width: tabWidth,
      decoration: BoxDecoration(
        color: isSelected
            ? appColorScheme.primaryLight
            : appColorScheme.primaryDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        border: Border(
          top: BorderSide(
            color: appColorScheme.strokeLight,
            width: 1,
          ),
          left: BorderSide(
            color: appColorScheme.strokeLight,
            width: 1,
          ),
          right: BorderSide(
            color: appColorScheme.strokeLight,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: appTextTheme.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? appColorScheme.textDark
                  : appColorScheme.textLight,
            ),
          ),
        ),
      ),
    );
  }
}