import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/widget/custom_appbar.dart';
import 'package:archivey/ui/auth/widget/custom_next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupSuccessPage extends StatelessWidget {
  const SignupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primaryLight,
        appBar: CustomAppbar(progressText: ''),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '환영해요! ',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '가입을 ',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: '완료',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '했어요.\n로그인 후 발견을 저장하고,\n취향을 쌓아보세요. ',
                      style: appText.bodyLarge.copyWith(
                        color: appColor.primaryDark,
                      ),
                    ),
                    WidgetSpan( // TODO TextSpan 안에 svg 이미지를 넣고 싶을 때, 어떻게 해야 하는지 문서
                      child: SvgPicture.asset(
                        'assets/icons/archivey_white.svg',
                        colorFilter: ColorFilter.mode(
                          appColor.primaryDark,
                          BlendMode.srcIn,
                        ),
                        height: appText.labelSmall.fontSize,
                      ),
                      alignment: PlaceholderAlignment.top,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: CustomNextButton(
          path: '/auth/sign-in',
          guide: '로그인',
        ),
      ),
    );
  }
}
