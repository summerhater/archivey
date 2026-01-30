import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:archivey/ui/auth/widget/custom_underline_text_field.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindEmailPasswordPage extends StatelessWidget {
  FindEmailPasswordPage({super.key});

  String _email = '';

  void _getEmail(String text) {
    _email = text;
  }

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primary,
        appBar: CustomAppbar(progressText: ''),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '가입하신 ',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryStrong,
                      ),
                    ),
                    TextSpan(
                      text: '이메일',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryStrong,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '을\n',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryStrong,
                      ),
                    ),
                    TextSpan(
                      text: '입력해 주세요.',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryStrong,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomUnderlineTextField(
                getText: _getEmail,
                hintText: '이메일 주소 입력',
              ),
            ],
          ),
        ),
        bottomSheet: CustomNextButton(
          path: '/auth/sign-in',
          guide: '비밀번호 재설정 메일 보내기',
          onPressed: () => context
              .read<AuthViewModel>()
              .resetPasswordWithEmail(_email)
              .then(
                (_) {
                  if(!context.mounted) return;
                  showSnackBar(
                    context,
                    '$_email로 비밀번호 재설정 메일을 보냈습니다.',
                  );
                },
              ),
        ),
      ),
    );
  }
}
