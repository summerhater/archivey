import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInCustomTextButton extends StatelessWidget {
  final String path;
  final String guide;
  final VoidCallback? asyncFunction;

  const SignInCustomTextButton({super.key, required this.path, required this.guide, this.asyncFunction,});

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return TextButton(
      onPressed: () {
        if(asyncFunction != null){
          asyncFunction!();
        } else {
          context.go(path);
        }
      },
      child: Text(
        guide,
        style: TextStyle(
          color: appColor.primaryLight,
          fontSize: appText.labelLarge.fontSize,
        )
      ),
    );
  }
}
