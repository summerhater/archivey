import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class SettingMenuItemWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final AppTextTheme appTextTheme;
  final AppColorScheme appColorScheme;
  final Widget? suffix;

  const SettingMenuItemWidget({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    required this.appTextTheme,
    required this.appColorScheme,
    this.suffix,
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
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    if (icon != null)
                      Icon(icon, size: 20, color: appColorScheme.primaryStrong),
                    if (icon != null) SizedBox(width: 12),
                    Text(
                      label,
                      style: appTextTheme.bodyMedium.copyWith(
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
        Divider(height: 48, color: appColorScheme.strokeLight),
      ],
    );
  }
}