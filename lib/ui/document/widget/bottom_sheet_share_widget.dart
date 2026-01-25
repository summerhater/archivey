import 'package:archivey/domain/model/more_icon_action_result_enum.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
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
  State<BottomSheetShareWidget> createState() => _BottomSheetShareWidgetState();
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
      child: Container(
        decoration: BoxDecoration(
          color: appColorScheme.primaryStrong,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: appColorScheme.primary,
              width: .5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
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
                  child: Text(
                    widget.shareSettingMode == ShareSettingMode.category
                        ? '카테고리 공유하기'
                        : '수집물 공유하기',
                    style: appTextTheme.headlineSmallKo.copyWith(
                      fontWeight: FontWeight.w500,
                      color: appColorScheme.primary,
                    ),
                  ),
                ),
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
                      context.pop(MoreIconActionResultEnum.share);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '링크 복사하기',
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primary,
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
                  }
                  ;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '카카오톡으로 공유하기',
                      style: appTextTheme.bodyMedium.copyWith(
                        color: appColorScheme.primary,
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
