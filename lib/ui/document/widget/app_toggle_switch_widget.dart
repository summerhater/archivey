import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';

class AppToggleSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggleSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: appColorScheme.primaryStrong,
      inactiveThumbColor: appColorScheme.textLight,
      inactiveTrackColor: appColorScheme.documentDetailBg,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (!value) {
            return appColorScheme.strokeLight;
          }
          return appColorScheme.primaryStrong;
        },
      ),
      trackOutlineWidth: WidgetStateProperty.resolveWith<double?>(
        (Set<WidgetState> states) {
          return 0.5;
        },
      ),
    );
  }
}
