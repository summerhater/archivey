import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class ReAuthenticationDialogWidget extends StatefulWidget {
  final Future<bool> Function(String) reAuthentication;
  final VoidCallback deleteAccount;

  const ReAuthenticationDialogWidget({super.key, required this.reAuthentication, required this.deleteAccount});

  @override
  State<ReAuthenticationDialogWidget> createState() => _ReAuthenticationDialogWidgetState();
}

class _ReAuthenticationDialogWidgetState extends State<ReAuthenticationDialogWidget> {
  final TextEditingController _controller = TextEditingController();
  final bool isError = false;

  bool visibility = false;

  @override
  void dispose() {
    _controller.dispose();
   super.dispose();
  }

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
              '비밀번호를 입력해주세요.',
              style: appTextTheme.headlineSmallKo.copyWith(
                color: appColorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              cursorColor: appColorScheme.primary,
              cursorWidth: 1.0,
              cursorHeight: 18,
              style: appTextTheme.headlineSmallKo.copyWith(
                fontWeight: FontWeight.w400,
                color: appColorScheme.primary,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '비밀번호 입력',
                hintStyle: appTextTheme.headlineSmallKo.copyWith(
                  color: appColorScheme.textLight,
                  fontWeight: FontWeight.w300,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? appColorScheme.error : appColorScheme.primary,
                    width: .5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? appColorScheme.error : appColorScheme.primary,
                    width: 1,
                  ),
                ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: Icon(
                      visibility
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      color: appColorScheme.textLight,
                    ),
                  ),
              ),
              obscureText: !visibility,
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
                    onPressed: () async{
                      if(await widget.reAuthentication(_controller.text)) {
                        Navigator.of(context).pop(true);
                      }
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
                      '확인',
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