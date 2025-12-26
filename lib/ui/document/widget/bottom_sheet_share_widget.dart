import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import 'delete_dialog_widget.dart';

enum ShareSettingMode { document, category }

class BottomSheetShareWidget extends StatefulWidget {
  final ShareSettingMode shareSettingMode;

  const BottomSheetShareWidget({
    super.key,
    required this.shareSettingMode,
  });

  @override
  State<BottomSheetShareWidget> createState() =>
      _BottomSheetShareWidgetState();
}

class _BottomSheetShareWidgetState extends State<BottomSheetShareWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,

      ///키보드 대응 핵심
      child: Container(
        decoration: BoxDecoration(
          color: appColorScheme.primaryDark,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: appColorScheme.primaryLight,
              width: .5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,///컨텐츠 내용만큼만으로 바텀시트 높이 제어
          children: [
            const SizedBox(height: 16),

            ///바텀시트 핸들
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(widget.shareSettingMode == ShareSettingMode.category
                      ? '카테고리 공유하기'
                      : '수집물 공유하기',
                    style: appTextTheme.headlineSmallKo.copyWith(
                      fontWeight: FontWeight.w500,
                      color: appColorScheme.primaryLight,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appColorScheme.textDark),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    context.pop();
                    if (widget.shareSettingMode == ShareSettingMode.category) {
                      ///todo: 카테고리 일 시 처리할 링크 생성+복사 로직
                      context.showAppSnackBar(
                        content: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                // text: '\'$newCategoryName\'',
                                text: 'newCategoryName',
                                style: appTextTheme.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: appColorScheme.primaryLight,
                                ),
                              ),
                              const TextSpan(text: ' 카테고리 링크가 복사되었습니다. \n원하는 곳에 붙여넣기 해보세요 ☻'),
                            ],
                            style: appTextTheme.bodySmall.copyWith(
                              height: 1.8,
                              color: appColorScheme.primaryLight,
                            ),
                          ),
                        ),
                      );
                    } else {
                      ///todo: 1개의 수집물(도큐먼트) 일 시 처리할 링크 복사 로직
                      context.showAppSnackBar(
                        content: Text('수집물 링크가 복사되었습니다. \n원하는 곳에 붙여넣기 해보세요 ☻',
                          style: appTextTheme.bodySmall.copyWith(
                            height: 1.8,
                            color: appColorScheme.primaryLight,
                          ),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    splashFactory: NoSplash.splashFactory,/// 탭할 시 애니메이션 제거
                    overlayColor: Colors.transparent,///탭할 시 하이라이트 제거
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '링크 복사하기',
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.pop();
                  if (widget.shareSettingMode == ShareSettingMode.category) {
                    ///todo: 카테고리 공유하는 링크 생성 및 카카오톡 보내기 바텀시트
                  } else {
                    ///todo: 카카오톡 보내기 바텀시트
                  };
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  splashFactory: NoSplash.splashFactory,/// 탭할 시 애니메이션 제거
                  overlayColor: Colors.transparent,///탭할 시 하이라이트 제거
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '카카오톡으로 공유하기',
                      style: appTextTheme.bodyMedium.copyWith(
                        color: appColorScheme.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
