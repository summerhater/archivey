import 'package:flutter/material.dart';

import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentDetailAiSummaryWidget extends StatelessWidget {
  final String aiSummary;

  const DocumentDetailAiSummaryWidget({
    super.key,
    required this.aiSummary,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          aiSummary,
          style: appTextTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w300,
            color: appColorScheme.textDark,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
