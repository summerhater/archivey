import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/widget/custom_tos_bottom_modal.dart';
import 'package:archivey/ui/auth/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/archivey_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.heightOf(context) * 0.4,
                  child: SvgPicture.asset('assets/icons/archivey_white.svg'),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                CustomElevatedButton(
                  path: '/auth/sign-in',
                  guide: '로그인',
                  backgroundColor: appColor.primaryStrong,
                  fontSize: appText.headlineSmallKo.fontSize,
                ),
                CustomElevatedButton(
                  path: '',
                  guide: '시작하기',
                  backgroundColor: Colors.transparent,
                  fontSize: appText.headlineSmallKo.fontSize,
                  onPressed: () async => await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => CustomTosBottomModal(path: '/auth/signup-email',),
                    backgroundColor: appColor.primary,
                    useSafeArea: true,
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
