import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/color_scheme_extension.dart';

class DocumentAllIndexPostCountWidget extends StatelessWidget {
  const DocumentAllIndexPostCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: appColorScheme.primaryDark,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Text('32', style: TextStyle(color: appColorScheme.primaryLight),),
          SizedBox(width: 3,),
          SvgPicture.asset(
            'assets/images/logo_variation_asterisk.svg',
            colorFilter: ColorFilter.mode(appColorScheme.primaryLight, BlendMode.srcIn),
            width: 18,
            height: 18,
          ),
        ],
      ),
    );
  }
}
