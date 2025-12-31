import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class DeleteAccountDialogWidget extends StatelessWidget {
  const DeleteAccountDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        decoration: BoxDecoration(
          color: appColorScheme.primaryStrong,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정말 탈퇴 하시겠어요?',
              style: appTextTheme.headlineSmallKo.copyWith(
                color: appColorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '탈퇴하시면 계정은 삭제되며,\n복구되지 않습니다.',
              style: appTextTheme.bodyMedium.copyWith(
                color: appColorScheme.primary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                      side: BorderSide(
                        color: appColorScheme.primary,
                        width: .5,
                      ),
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // todo: 탈퇴 로직
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                      backgroundColor: appColorScheme.errorBg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '탈퇴',
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