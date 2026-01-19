import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

enum DeleteSettingMode { category, document }

class DeleteDialogWidget extends StatelessWidget {
  final DeleteSettingMode deleteSettingMode;
  const DeleteDialogWidget({
    super.key,
    required this.deleteSettingMode,
  });

  String settingModeToString() {
    if (deleteSettingMode == DeleteSettingMode.category) {
      return '카테고리';
    }
    return '수집물';
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Dialog(
      child: Container(
        width: 300,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        decoration: BoxDecoration(
          color: appColorScheme.primaryStrong,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text.rich(
                  style: appTextTheme.headlineSmallKo.copyWith(
                    color: appColorScheme.primary,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: settingModeToString(),
                      ),
                      TextSpan(
                        text: ' 삭제',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              deleteSettingMode == DeleteSettingMode.category
                  ? '삭제 시 categoryname에 수집된 내용은 모두 삭제되며 복구할 수 없습니다.'
                  : '삭제 시 해당 수집물은 삭제되며, 삭제 후 복구할 수 없습니다.',
              style: appTextTheme.bodyMedium.copyWith(
                color: appColorScheme.primary,
                height: 1.6,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                      side: BorderSide(
                        color: appColorScheme.primary,
                        width: .5,
                      ),
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: appTextTheme.bodyMedium.copyWith(
                        color: appColorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                      backgroundColor: appColorScheme.errorBg,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '삭제',
                      style: appTextTheme.bodyMedium.copyWith(
                        color: appColorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
