import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNextButton extends StatelessWidget {
  final String guide;
  final String path;
  final Future<void> Function()? onPressed;

  const CustomNextButton({
    super.key,
    required this.path,
    required this.guide,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if(onPressed != null) {
              await onPressed!();
              if(!context.mounted) return;
            }
            context.go(path);
          } catch (error) {
            showSnackBar(
              context,
              error.toString(),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor.primaryStrong,
          shape: BeveledRectangleBorder(),
        ),
        child: Center(
          child: Text(
            guide,
            style: appText.headlineSmallKo.copyWith(
              color: appColor.primary,
            )
          ),
        ),
      ),
    );
  }
}
