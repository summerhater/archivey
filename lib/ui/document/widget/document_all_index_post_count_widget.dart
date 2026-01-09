import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentAllIndexPostCountWidget extends StatelessWidget {
  const DocumentAllIndexPostCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: appColorScheme.primaryStrong,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Text(
            ///todo: 해당 카테고리에 저장된 수집물 갯수 가져오기
            '32',
            style: appTextTheme.bodyLarge.copyWith(
              color: appColorScheme.primary,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          SvgPicture.asset(
            'assets/images/logo_variation_asterisk.svg',
            colorFilter: ColorFilter.mode(
              appColorScheme.primary,
              BlendMode.srcIn,
            ),
            width: 18,
            height: 18,
          ),
        ],
      ),
    );
  }
}
