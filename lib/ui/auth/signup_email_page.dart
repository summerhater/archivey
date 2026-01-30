import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_underline_text_field.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupEmailPage extends StatelessWidget {
  SignupEmailPage({super.key});

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
        appBar: CustomAppbar(progressText: '1/3'),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '가입하실 ',
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
              CustomUnderlineTextField(getText: _getEmail, hintText: '이메일 주소 입력'),
            ],
          ),
        ),
        //todo:jh CustomNextButton action을 onPressed에 모아서 처리하는 방향도 생각해보기
        bottomSheet: CustomNextButton(
          path: '/auth/signup-email/signup-password',
          guide: '다음',
          onPressed: () => context.read<AuthViewModel>().isAlreadyExistEmail(_email),
        ),
      ),
    );
  }
}
