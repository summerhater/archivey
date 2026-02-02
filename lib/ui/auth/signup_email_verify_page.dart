import 'dart:io';

import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:archivey/ui/auth/widget/sign_up_back_button_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SignupEmailVerifyPage extends StatelessWidget {
  const SignupEmailVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;
    final vm = context.read<AuthViewModel>();

    return SignUpBackButtonHandler(
      child: SafeArea(
        top: !Platform.isIOS,
        bottom: !Platform.isIOS,
        child: Scaffold(
          backgroundColor: appColor.primary,
          appBar: CustomAppbar(progressText: '3/3',isSignUp: true),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이메일을 전송했어요.',
                  style: appText.bodyLarge.copyWith(
                    color: appColor.primaryStrong,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '전송된 링크로 접속해 ',
                        style: appText.bodyMedium.copyWith(
                          color: appColor.primaryStrong,
                        ),
                      ),
                      TextSpan(
                        text: '인증완료 후,\n',
                        style: appText.bodyMedium.copyWith(
                          color: appColor.primaryStrong,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '다음 ',
                        style: appText.bodyMedium.copyWith(
                          color: appColor.primaryStrong,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '버튼을 눌러 진행해 주세요.',
                        style: appText.bodyMedium.copyWith(
                          color: appColor.primaryStrong,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          bottomSheet: CustomNextButton(
            path: '/auth/signup-success/',
            guide: '다음',
            onPressed: () => vm.isVerifyEmail(),
          ),
        ),
      ),
    );
  }
}
