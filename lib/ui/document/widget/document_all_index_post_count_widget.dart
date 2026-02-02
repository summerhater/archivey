import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

class DocumentAllIndexDocumentCountWidget extends StatefulWidget {
  final int documentCount;
  const DocumentAllIndexDocumentCountWidget({
    super.key,
    required this.documentCount,
  });

  @override
  State<DocumentAllIndexDocumentCountWidget> createState() => _DocumentAllIndexDocumentCountWidgetState();
}

class _DocumentAllIndexDocumentCountWidgetState extends State<DocumentAllIndexDocumentCountWidget> {
  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    print('documentCount in widget: ${widget.documentCount}');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: appColorScheme.primaryStrong,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Text(
            widget.documentCount.toString(),
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
