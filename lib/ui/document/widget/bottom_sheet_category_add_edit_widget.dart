import 'dart:io';

import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

enum CategorySettingMode { add, edit, subAdd, subEdit }

class BottomSheetCategoryAddEditWidget extends StatefulWidget {
  final CategorySettingMode categorySettingMode;
  final CategoryModel? originalCategoryModel;
  final String? parentCategoryId;

  const BottomSheetCategoryAddEditWidget({
    super.key,
    required this.categorySettingMode,
    this.originalCategoryModel,
    this.parentCategoryId,
  });

  @override
  State<BottomSheetCategoryAddEditWidget> createState() =>
      _BottomSheetCategoryAddEditWidgetState();
}

class _BottomSheetCategoryAddEditWidgetState
    extends State<BottomSheetCategoryAddEditWidget> {
  bool _isSaving = false;
  String _inputValue = '';
  bool _hasSubmitted = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isAlreadyInUseCategory = false;
  bool _isInputEmpty = false;
  bool isIosMobile = !kIsWeb && Platform.isIOS;
  String get _trimmedValue => _inputValue.trim();

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryViewModel>(context, listen: false).readCategory();

    if (widget.categorySettingMode == CategorySettingMode.edit ||
        widget.categorySettingMode == CategorySettingMode.subEdit &&
            widget.originalCategoryModel != null) {
      _controller.text = widget.originalCategoryModel!.categoryName;
      _inputValue = widget.originalCategoryModel!.categoryName;
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
    final bool isError = _hasSubmitted && _inputValue.isEmpty;
    final maxLength = 15;

    return SafeArea(
      top: false,
      bottom: !isIosMobile,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,

        child: Consumer<CategoryViewModel>(
          builder: (context, vm, _) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                  Row(
                    children: [
                      Text(
                        widget.categorySettingMode == CategorySettingMode.add
                            ? '새 카테고리 추가'
                            : widget.categorySettingMode ==
                                  CategorySettingMode.subAdd
                            ? '새 소분류 카테고리 추가'
                            : widget.categorySettingMode ==
                                  CategorySettingMode.edit
                            ? '카테고리 수정'
                            : '소분류 카테고리 수정',
                        style: appTextTheme.headlineSmallKo.copyWith(
                          color: appColorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _inputValue = value; // 텍스트가 바뀌면 에러 상태 초기화
                        if (_isAlreadyInUseCategory)
                          _isAlreadyInUseCategory = false;
                        if (_hasSubmitted && value.isNotEmpty) {
                          _hasSubmitted = false;
                        }
                      });
                    },
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLength: 15,
                    cursorColor: appColorScheme.primary,
                    cursorWidth: 1.0,
                    cursorHeight: 18,
                    style: appTextTheme.headlineSmallKo.copyWith(
                      fontWeight: FontWeight.w400,
                      color: appColorScheme.primary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText:
                          widget.categorySettingMode == CategorySettingMode.add
                          ? '카테고리 이름을 입력해 주세요'
                          : widget.categorySettingMode ==
                                CategorySettingMode.subAdd
                          ? '소분류 카테고리 이름을 입력해 주세요'
                          : widget.categorySettingMode ==
                                CategorySettingMode.edit
                          ? '변경할 카테고리 이름을 입력해 주세요'
                          : '변경할 소분류 카테고리 이름을 입력해 주세요',
                      hintStyle: appTextTheme.headlineSmallKo.copyWith(
                        color: appColorScheme.textLight,
                        fontWeight: FontWeight.w300,
                      ),
                      helperText: _isAlreadyInUseCategory ? null : ' ',
                      helperStyle: appTextTheme.labelLarge.copyWith(
                        color: appColorScheme.error,
                      ),
                      errorText: _hasSubmitted && _trimmedValue.isEmpty
                          ? '카테고리 이름을 입력해 주세요'
                          : _isAlreadyInUseCategory
                          ? '이미 존재하는 카테고리 이름입니다. 다른 이름을 입력해 주세요.'
                          : null,
                      errorStyle: appTextTheme.labelLarge.copyWith(
                        color: appColorScheme.error,
                      ),
                      suffix: Text(
                        '${_inputValue.length} / $maxLength',
                        style: appTextTheme.labelLarge.copyWith(
                          color: appColorScheme.textLight,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: isError
                              ? appColorScheme.error
                              : appColorScheme.primary,
                          width: .5,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: (isError || _isAlreadyInUseCategory)
                              ? appColorScheme.error
                              : appColorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              final trimmedValue = _inputValue.trim();

                              setState(() {
                                _isSaving = true;
                                _hasSubmitted = true;
                                _isAlreadyInUseCategory = false;
                              });

                              if (trimmedValue.isEmpty) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _isInputEmpty = true;
                                });
                                return;
                              }

                              ///중복체크로직 시작
                              final String? currentParentId =
                                  (widget.categorySettingMode ==
                                      CategorySettingMode.subAdd)
                                  ? widget.parentCategoryId
                                  : null;

                              ///제외할 ID결정 (수정 모드일 때만 현재 카테고리모델 ID 전달)
                              final String? excludeId =
                                  (widget.categorySettingMode ==
                                      CategorySettingMode.edit)
                                  ? widget.originalCategoryModel?.categoryId
                                  : null;

                              bool isDuplicate = vm.isAlreadyInUseCategory(
                                trimmedValue,
                                currentParentId,
                                excludeId: excludeId,
                              );

                              if (isDuplicate) {
                                setState(() {
                                  _isSaving = false;
                                  _isAlreadyInUseCategory = true;
                                });
                                HapticFeedback.heavyImpact();
                                return;
                              }

                              try {
                                if (widget.categorySettingMode ==
                                    CategorySettingMode.add) {
                                  await vm.createCategory(trimmedValue);
                                } else if (widget.categorySettingMode ==
                                    CategorySettingMode.subAdd) {
                                  await vm.createCategory(
                                    trimmedValue,
                                    parentId: widget.parentCategoryId,
                                  );
                                } else {
                                  if (widget.originalCategoryModel != null) {
                                    await vm.updateCategory(
                                      widget.originalCategoryModel!,
                                      trimmedValue,
                                    );
                                  }
                                }

                                if (!mounted) return;
                                context.pop(trimmedValue);
                              } catch (e) {
                                setState(() {
                                  _isSaving = false;
                                });
                                if (!mounted) return;
                                context.showAppMessageSnackBar(
                                  '카테고리 작업 실패: $e',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: appColorScheme.primary,
                        disabledBackgroundColor: appColorScheme.primary
                            .withValues(alpha: 0.6),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        overlayColor: Colors.transparent,
                      ),
                      child: _isSaving
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      appColorScheme.textLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '저장 중...',
                                  style: appTextTheme.bodyMedium.copyWith(
                                    color: appColorScheme.textLight,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              '저장',
                              style: appTextTheme.bodyMedium.copyWith(
                                color: appColorScheme.primaryStrong,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
