import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_more_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MoreIconSettingMode { category, document }

class MoreIconWidget extends StatelessWidget {
  final DocumentModel? document;
  final MoreIconSettingMode moreIconSettingMode;
  const MoreIconWidget({super.key, required this.moreIconSettingMode, this.document});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet<String>(
          isScrollControlled: true,
          context: context,
          useRootNavigator: true,
          builder: (_) => BottomSheetWithNoHeaderWidget(
            typeSettingMode: moreIconSettingMode == MoreIconSettingMode.category
                ? TypeSettingMode.category
                : TypeSettingMode.document,
            document: moreIconSettingMode == MoreIconSettingMode.document
              ? document : null,
          ),
        );
      },
      icon: Icon(Icons.more_vert),
      iconSize: 18,
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity(horizontal: -4.0),
    );
  }
}
