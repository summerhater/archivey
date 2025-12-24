import 'package:flutter/material.dart';

import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class CustomSnackBarWidget extends StatelessWidget {
  final String text;
  const CustomSnackBarWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return SnackBar(
      backgroundColor: appColorScheme.snackBarBg,
        content: Text(
          text,
          style: appTextTheme.bodySmall.copyWith(
            color: appColorScheme.primaryLight,

          ),
        ),
    );
  }
}
