import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_more_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MoreIconSettingMode { category, document, documentDetail }

class MoreIconWidget extends StatelessWidget {
  final DocumentModel? document;
  final MoreIconSettingMode moreIconSettingMode;
  final VoidCallback? onEditPressed;
  const MoreIconWidget({super.key, required this.moreIconSettingMode, this.document, this.onEditPressed,});

  @override
  Widget build(BuildContext context) {
    // print("전달 전 확인 in more icon widget: ${document?.title}, ${document?.memo}");
    return IconButton(
      onPressed: () {
        showModalBottomSheet<String>(
          isScrollControlled: true,
          context: context,
          useRootNavigator: true,
          builder: (_) => BottomSheetWithNoHeaderWidget(
            typeSettingMode: moreIconSettingMode == MoreIconSettingMode.category
                ? TypeSettingMode.category
                : moreIconSettingMode == MoreIconSettingMode.document
                ? TypeSettingMode.document : TypeSettingMode.documentDetail,
            document: document,
            onEditPressed: onEditPressed,
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
