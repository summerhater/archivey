import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';

class VerticalTabNavigation extends StatelessWidget {
  final ValueChanged<int> onTapChanged;
  final int selectedIndex;

  const VerticalTabNavigation({
    super.key,
    required this.onTapChanged,
    required this.selectedIndex,
  });

  ///탭 하나가 차지할 고정 높이
  static const double tabHeight = 170.0;

  ///탭끼리 겹칠 간격
  static const double overlap = 20.0;

  static const List<String> _categories = [
    'ALL',
    '위시리스트입니다',
    '취업',
    'wishlist haha',
    '여행입니다만',
    '공부',
    '운동',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    return SizedBox(
      width: 32,
      child: Container(

        ///all탭 선택 시 상단 패딩 배경 색
        color: selectedIndex == 0
            ? appColorScheme.primaryLight
            : appColorScheme.primaryDark,
        child: Column(
          children: [

            /// 스크롤 가능한 우측 탭바 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: appColorScheme.primaryLight,
                      width: .5,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                primary: false,
                  padding: EdgeInsets.only(

                    ///상단 상태바 높이만큼 패딩주기
                    top: 30,
                  ),
                  child: Container(
                    color: appColorScheme.primaryDark,

                    ///탭 개수에 따른 전체 길이 설정
                    height: (_categories.length * tabHeight) - 80,
                    child: Stack(children: _buildTopFirstStackedTabs(context)),
                  ),
                ),
              ),
            ),

            /// 하단 고정 설정 영역(settings, add button)
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appColorScheme.primaryLight,
                    width: .5,
                  ),
                  right: BorderSide(
                    color: appColorScheme.primaryLight,
                    width: .5,
                  ),
                ),
                color: Color(0xFF1A1A1A),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: appColorScheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .padding
                    .bottom + 20,
                top: 20,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appColorScheme.primaryLight,
                    width: .5,
                  ),
                  right: BorderSide(
                    color: appColorScheme.primaryLight,
                    width: .5,
                  ),
                ),
                color: Color(0xFF1A1A1A),
              ),
              child: Center(
                child: Icon(
                  Icons.settings_outlined,
                  color: appColorScheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopFirstStackedTabs(context, ) {
    return _categories
        .asMap()
        .entries
        .map((entry) {
      int idx = entry.key;
      bool isSelected = selectedIndex == idx;

      return Positioned(
        ///아래로 갈수록 각 탭의 top 값 커지게
        top: idx * (tabHeight - overlap),
        left: 0,
        right: 0,
        child: GestureDetector(
          // onTap: () => setState(() => selectedIndex = idx),
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
    return Container(
      height: tabHeight,
      decoration: BoxDecoration(
        color: isSelected ? appColorScheme.primaryLight : appColorScheme.primaryDark,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(color: appColorScheme.primaryLight, width: .5),
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
                textAlign: TextAlign.end,
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? appColorScheme.textDark : appColorScheme.textLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}