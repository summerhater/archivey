import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomElevatedButton extends StatelessWidget {
  final String path;
  final String guide;
  final Color backgroundColor;
  final double? fontSize;
  final VoidCallback? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.path,
    required this.guide,
    required this.backgroundColor,
    required this.fontSize,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            context.go(path);
          }
        },
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: appColor.primary,
              width: .5,
            ),
          ),
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(20),
        ),
        child: Text(
          guide,
          style: TextStyle(
            color: appColor.primary,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
