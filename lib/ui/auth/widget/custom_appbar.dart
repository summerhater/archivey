import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String progressText;

  const CustomAppbar({super.key, required this.progressText});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;
    
    return AppBar(
      leading: context.canPop() ? IconButton(
        onPressed: () {
          context.pop(context);
        },
        icon: Icon(Icons.chevron_left, color: appColor.textLight),
      ) : null,
      actions: [
        TextButton(
          onPressed: null,
          child: Text(
            progressText,
            style: appText.labelLarge.copyWith(
              color: appColor.textLight,
            )
          ),
        ),
      ],
    );
  }

}
