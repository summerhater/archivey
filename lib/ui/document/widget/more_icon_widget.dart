import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/more_icon_action_result_enum.dart';
import 'package:flutter/material.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_more_action_widget.dart';


enum MoreIconSettingMode { category, document, documentDetail }

class MoreIconWidget extends StatelessWidget {
  final DocumentModel? document;
  final MoreIconSettingMode moreIconSettingMode;
  final VoidCallback? onEditPressed;
  final CategoryModel? originalCategoryModel;
  final VoidCallback? onDeleteConfirmed;
  final VoidCallback? onCopyLinkConfirmed;
  final VoidCallback? onShareKakaoConfirmed;

  const MoreIconWidget({
    super.key,
    required this.moreIconSettingMode,
    this.document,
    this.onEditPressed,
    this.originalCategoryModel,
    this.onDeleteConfirmed,
    this.onCopyLinkConfirmed,
    this.onShareKakaoConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    // print("전달 전 확인 in more icon widget: ${document?.title}, ${document?.memo}");
    return IconButton(
      onPressed: () async {
        final result = await showModalBottomSheet<MoreIconActionResultEnum>(
          isScrollControlled: true,
          context: context,
          useRootNavigator: true,
          builder: (_) => BottomSheetMoreActionWidget(
            isSubCategory: false,
            typeSettingMode: moreIconSettingMode == MoreIconSettingMode.category
                ? TypeSettingMode.category
                : moreIconSettingMode == MoreIconSettingMode.document
                ? TypeSettingMode.document
                : TypeSettingMode.documentDetail,
            document: document,
            onEditPressed: onEditPressed,
            originalCategoryModel: originalCategoryModel,
          ),
        );

        switch (result) {
          case MoreIconActionResultEnum.delete:
            onDeleteConfirmed!();
            break;
          case MoreIconActionResultEnum.copyLink:
            onCopyLinkConfirmed!();
          case MoreIconActionResultEnum.shareKakao:
            onShareKakaoConfirmed!();
          case null:
            print('null error in MoreIconWidget()');
            // throw UnimplementedError();
        }
        // if (result == MoreIconActionResultEnum.delete) {
        //   onDeleteConfirmed!();
        // }
      },
      icon: Icon(Icons.more_vert),
      iconSize: 18,
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity(horizontal: -4.0),
    );
  }
}
