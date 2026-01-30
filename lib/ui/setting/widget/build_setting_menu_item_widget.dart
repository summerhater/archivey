import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class SettingMenuItemWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final AppTextTheme appTextTheme;
  final AppColorScheme appColorScheme;
  final Widget? suffix;
  final bool? isSubWidget;

  const SettingMenuItemWidget({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    required this.appTextTheme,
    required this.appColorScheme,
    this.suffix,
    this.isSubWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: !(isSubWidget ?? false) ? EdgeInsets.symmetric(vertical: 14) : EdgeInsetsGeometry.symmetric(vertical: 5),
                child: Row(
                  children: [
                    if (icon != null)
                      Icon(icon, size: 20, color: appColorScheme.primaryStrong),
                    if (icon != null) SizedBox(width: 12),
                    Text(
                      label,
                      style: (isSubWidget ?? false) ? appTextTheme.bodySmall.copyWith(
                        color: appColorScheme.primaryStrong,
                        fontWeight: FontWeight.w300,
                      ) : appTextTheme.bodyMedium.copyWith(
                        color: icon != null
                            ? appColorScheme.primaryStrong
                            : appColorScheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ?suffix,
          ],
        ),
        // Divider(height: 48, color: appColorScheme.strokeLight),
      ],
    );
  }
}