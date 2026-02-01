import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/widget/sign_up_cancel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String progressText;
  final bool isSignUp;

  const CustomAppbar({super.key, required this.progressText, required this.isSignUp});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;
    
    return AppBar(
      backgroundColor: appColor.primary,
      leading: isSignUp ? IconButton(
        onPressed: () async {
          final bool? isCancel = await showDialog(context: context, builder: (context) => SignUpCancelDialog());
          if(isCancel == null || !isCancel) return;
          context.go('/auth');
        },
        icon: Icon(Icons.chevron_left, color: appColor.textLight),
      ): context.canPop() ? IconButton(
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
