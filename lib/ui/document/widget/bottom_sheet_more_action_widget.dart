import 'dart:io';

import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/model/more_icon_action_result_enum.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import 'bottom_sheet_share_widget.dart';
import 'delete_dialog_widget.dart';

enum TypeSettingMode { category, document, documentDetail }

class BottomSheetMoreActionWidget extends StatefulWidget {
  final bool isSubCategory;
  final TypeSettingMode typeSettingMode;
  final DocumentModel? document;
  final VoidCallback? onEditPressed;
  final CategoryModel? originalCategoryModel;
  final ValueChanged<MoreIconActionResultEnum>? onCopyLinkPressed;
  final ValueChanged<MoreIconActionResultEnum>? onShareKakaoPressed;
  final CategorySettingMode? categorySettingMode;

  const BottomSheetMoreActionWidget({
    super.key,
    required this.isSubCategory,
    required this.typeSettingMode,
    this.document,
    this.onEditPressed,
    this.originalCategoryModel,
    this.onCopyLinkPressed,
    this.onShareKakaoPressed,
    this.categorySettingMode,
  });

  @override
  State<BottomSheetMoreActionWidget> createState() =>
      _BottomSheetMoreActionWidgetState();
}

class _BottomSheetMoreActionWidgetState
    extends State<BottomSheetMoreActionWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isIosMobile = !kIsWeb && Platform.isIOS;

  /// 삭제 다이얼로그를 띄우고, 사용자의 선택 결과를 반환한다.
  Future<MoreIconActionResultEnum?> deleteByTypeSettingModeFromBottomSheet() async {
    final deleteMode = widget.typeSettingMode == TypeSettingMode.category
        ? DeleteSettingMode.category
        : DeleteSettingMode.document;

    final MoreIconActionResultEnum? result =
        await showDialog<MoreIconActionResultEnum>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DeleteDialogWidget(
          deleteSettingMode: deleteMode,
        );
      },
    );

    return result;
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

    return SafeArea(
      top: false,
      bottom: !isIosMobile,
      child: Padding(
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
                    onPressed: () async {
                      context.pop();
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        useRootNavigator: true,
                        builder: (_) => BottomSheetShareWidget(
                          shareSettingMode:
                              widget.typeSettingMode == TypeSettingMode.category
                              ? ShareSettingMode.category
                              : ShareSettingMode.document,
                            onCopyLinkPressed:widget.onCopyLinkPressed,
                            onShareKakaoPressed:widget.onShareKakaoPressed,
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
                  onPressed: () async {
                    final MoreIconActionResultEnum? result =
                        await deleteByTypeSettingModeFromBottomSheet();
                    if (!context.mounted) return;
                    if (result != null) {
                      context.pop(result);
                    }
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
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
