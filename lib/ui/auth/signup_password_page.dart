import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_underline_text_field.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPasswordPage extends StatefulWidget {
  const SignupPasswordPage({super.key});

  @override
  State<SignupPasswordPage> createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  bool pwVisibility = false;
  bool rePwVisibility = false;
  final TextEditingController _pw = TextEditingController();
  final TextEditingController _pwVerify = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primaryLight,
        appBar: CustomAppbar(progressText: '2/3'),
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
                        color: appColor.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: '비밀번호',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '를 입력해 주세요.',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomUnderlineTextField(controller: _pw, hintText: '비밀번호 입력', isPassword: true,),
              SizedBox(
                height: 20,
              ),
              CustomUnderlineTextField(controller: _pwVerify, hintText: '비밀번호를 다시 한번 입력해 주세요', isPassword: true,),
            ],
          ),
        ),
        bottomSheet: CustomNextButton(
          path: '/auth/signup-email/signup-password/signup-email-verify',
          guide: '다음',
          onPressed: () async => await context.read<AuthViewModel>().signUpWithEmailAndPassword(_pw.text, _pwVerify.text),
        ),
      ),
    );
  }
}
