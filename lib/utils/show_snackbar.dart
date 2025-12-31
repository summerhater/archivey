import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  var appColor = Theme.of(context).extension<AppColorScheme>()!;
  var appText = Theme.of(context).extension<AppTextTheme>()!;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: appText.bodySmall.copyWith(
        color: appColor.primaryLight,
      ),),
      backgroundColor: appColor.snackBarBg,
    )
  );
}