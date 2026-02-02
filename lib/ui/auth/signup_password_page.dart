import 'dart:io';

import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_underline_text_field.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:archivey/ui/auth/widget/sign_up_back_button_handler.dart';
import 'package:archivey/utils/dismiss_keyboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SignupPasswordPage extends StatefulWidget {
  const SignupPasswordPage({super.key});

  @override
  State<SignupPasswordPage> createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  String _password = '';
  String _passwordVerify = '';

  void _getPassword(String text) {
    _password = text;
  }

  void _getPasswordVerify(String text) {
    _passwordVerify = text;
  }

  bool pwVisibility = false;
  bool rePwVisibility = false;

  bool isIosMobile = !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return DismissKeyboard(
      child: SignUpBackButtonHandler(
        child: SafeArea(
          top: false,
          bottom: !isIosMobile,
          child: Scaffold(
            backgroundColor: appColor.primary,
            appBar: CustomAppbar(progressText: '2/3',isSignUp: true,),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '사용하실',
                          style: appText.bodyLarge.copyWith(
                            color: appColor.primaryStrong,
                          ),
                        ),
                        TextSpan(
                          text: ' 비밀번호',
                          style: appText.bodyLarge.copyWith(
                            color: appColor.primaryStrong,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '를 입력해 주세요.',
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
                    getText: _getPassword,
                    hintText: '비밀번호 입력',
                    isPassword: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomUnderlineTextField(
                    getText: _getPasswordVerify,
                    hintText: '비밀번호를 다시 한번 입력해 주세요',
                    isPassword: true,
                  ),
                ],
              ),
            ),
            bottomSheet: CustomNextButton(
              path: '/auth/signup-email/signup-password/signup-email-verify',
              guide: '다음',
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                return await context
                    .read<AuthViewModel>()
                    .signUpWithEmailAndPassword(_password, _passwordVerify);
              }
            ),
          ),
        ),
      ),
    );
  }
}
