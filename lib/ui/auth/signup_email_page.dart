import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_underline_text_field.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupEmailPage extends StatelessWidget {
  const SignupEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    final TextEditingController _controller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primaryLight,
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
                      style: TextStyle(
                        fontSize: appText.bodyLarge.fontSize,
                        color: appColor.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: '이메일',
                      style: TextStyle(
                        fontSize: appText.bodyLarge.fontSize,
                        fontWeight: FontWeight.bold,
                        color: appColor.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: '을\n',
                      style: TextStyle(
                        fontSize: appText.bodyLarge.fontSize,
                        color: appColor.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: '입력해 주세요.',
                      style: TextStyle(
                        fontSize: appText.bodyLarge.fontSize,
                        color: appColor.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 40,
                color: Colors.transparent,
              ),
              CustomUnderlineTextField(controller: _controller, hintText: '이메일 주소 입력'),
            ],
          ),
        ),
        bottomSheet: CustomNextButton(
          path: '/auth/signup-email/signup-password',
          guide: '다음',
          vmAsyncFunction: () => context.read<AuthViewModel>().isAlreadyExistEmail(_controller.text),
        ),
      ),
    );
  }
}
