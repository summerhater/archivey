import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import 'bottom_sheet_share_widget.dart';
import 'delete_dialog_widget.dart';

enum TypeSettingMode { document, category }

class BottomSheetWithNoHeaderWidget extends StatefulWidget {
  final DocumentModel? document;
  final TypeSettingMode typeSettingMode;

  const BottomSheetWithNoHeaderWidget({
    super.key,
    required this.typeSettingMode,
    this.document,
  });

  @override
  State<BottomSheetWithNoHeaderWidget> createState() =>
      _BottomSheetWithNoHeaderWidgetState();
}

class _BottomSheetWithNoHeaderWidgetState extends State<BottomSheetWithNoHeaderWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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

      ///키보드 대응 핵심
      child: Container(
        decoration: BoxDecoration(
          color: appColorScheme.primaryDark,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: appColorScheme.primaryLight,
              width: .5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,///컨텐츠 내용만큼만으로 바텀시트 높이 제어
          children: [
            const SizedBox(height: 16),

            ///바텀시트 핸들
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

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
                        shareSettingMode: widget.typeSettingMode == TypeSettingMode.category
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
                          color: appColorScheme.primaryLight,
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
                    Navigator.of(context).pop();
                    if (widget.typeSettingMode == TypeSettingMode.category) {
                      showModalBottomSheet<String>(
                        isScrollControlled: true,
                        context: context,
                        useRootNavigator: true,
                        builder: (_) => BottomSheetCategoryAddEditWidget(categorySettingMode: CategorySettingMode.edit),
                      );
                    } else {
                      context.go('/document_all_total/detail', extra: widget.document,);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    splashFactory: NoSplash.splashFactory,/// 탭할 시 애니메이션 제거
                    overlayColor: Colors.transparent,///탭할 시 하이라이트 제거
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.typeSettingMode == TypeSettingMode.category ? '카테고리 수정하기': '수집물 보기',
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primaryLight,
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
                  if (widget.typeSettingMode == TypeSettingMode.category) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return DeleteDialogWidget(deleteSettingMode: DeleteSettingMode.category,);
                        }
                    );
                  } else {
                    //1개의 수집물(도큐먼트) 일 시 처리할 삭제 로직
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return DeleteDialogWidget(deleteSettingMode: DeleteSettingMode.document,);
                        }
                    );
                  }
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
