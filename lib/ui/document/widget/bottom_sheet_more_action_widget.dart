import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import '../../../domain/model/document_model_on_progress.dart';
import 'bottom_sheet_share_widget.dart';
import 'delete_dialog_widget.dart';

enum TypeSettingMode { category, document, documentDetail }

class BottomSheetMoreActionWidget extends StatefulWidget {
  final bool isSubCategory;
  final TypeSettingMode typeSettingMode;
  final DocumentModel? document;
  final VoidCallback? onEditPressed;
  final CategoryModel? originalCategoryModel;

  const BottomSheetMoreActionWidget({
    super.key,
    required this.isSubCategory,
    required this.typeSettingMode,
    this.document,
    this.onEditPressed,
    this.originalCategoryModel,
  });

  @override
  State<BottomSheetMoreActionWidget> createState() =>
      _BottomSheetMoreActionWidgetState();
}

class _BottomSheetMoreActionWidgetState
    extends State<BottomSheetMoreActionWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void deleteByTypeSettingModeFromBottomSheet(){
    if (widget.typeSettingMode == TypeSettingMode.category) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DeleteDialogWidget(
            deleteSettingMode: DeleteSettingMode.category,
          );
        },
      );
    } else {
      ///1개의 수집물(도큐먼트) 일 시 처리할 삭제 로직
      context.pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DeleteDialogWidget(
            deleteSettingMode: DeleteSettingMode.document,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,

      child: Container(
        decoration: BoxDecoration(
          color: appColorScheme.primaryStrong,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: appColorScheme.primary,
              width: .5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container( ///바텀시트 핸들
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            if (!widget.isSubCategory)
              SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appColorScheme.textDark),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    context.pop();
                    showModalBottomSheet<String>(
                      isScrollControlled: true,
                      context: context,
                      useRootNavigator: true,
                      builder: (_) => BottomSheetShareWidget(
                        shareSettingMode:
                            widget.typeSettingMode == TypeSettingMode.category
                            ? ShareSettingMode.category
                            : ShareSettingMode.document,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    splashFactory: NoSplash.splashFactory,/// 탭할 시 애니메이션 제거
                    overlayColor: Colors.transparent,///탭할 시 하이라이트 제거
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '공유하기',
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appColorScheme.textDark),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    context.pop();
                    if (widget.typeSettingMode == TypeSettingMode.category) {
                      final categorySettingMode = widget.isSubCategory
                          ? CategorySettingMode.subEdit
                          : CategorySettingMode.edit;

                      showModalBottomSheet<String>(
                        isScrollControlled: true,
                        context: context,
                        useRootNavigator: true,
                        builder: (_) => BottomSheetCategoryAddEditWidget(
                          categorySettingMode: categorySettingMode,
                          originalCategoryModel: widget.originalCategoryModel,
                        ),
                      );
                    }
                    else if (widget.typeSettingMode ==
                        TypeSettingMode.document) {
                      context.go(
                        '/document_all_total/detail',
                        extra: widget.document,
                      );
                    } else {
                      ///todo: 도큐먼트 상세보기 페이지 수정하기 로직
                      if (widget.onEditPressed != null) {
                        widget.onEditPressed!();
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.typeSettingMode == TypeSettingMode.category
                            ? '카테고리 수정하기'
                            : widget.typeSettingMode == TypeSettingMode.document
                            ? '수집물 보기'
                            : '수정하기',
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  deleteByTypeSettingModeFromBottomSheet();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '삭제하기',
                      style: appTextTheme.bodyMedium.copyWith(
                        color: appColorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
