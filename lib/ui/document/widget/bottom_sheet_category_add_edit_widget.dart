import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';

enum CategorySettingMode { add, edit }

class BottomSheetCategoryAddEditWidget extends StatefulWidget {
  final CategorySettingMode categorySettingMode;

  const BottomSheetCategoryAddEditWidget({
    super.key,
    required this.categorySettingMode,
  });

  @override
  State<BottomSheetCategoryAddEditWidget> createState() =>
      _BottomSheetCategoryAddEditWidgetState();
}

class _BottomSheetCategoryAddEditWidgetState
    extends State<BottomSheetCategoryAddEditWidget> {
  String _inputValue = '';
  bool _hasSubmitted = false;
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
    final bool isError = _hasSubmitted && _inputValue.isEmpty;
    final maxLength = 15;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                      : '카테고리 수정',
                  style: appTextTheme.headlineSmallKo.copyWith(
                    color: appColorScheme.primaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              ///바텀시트 뜨자마자 키보드 올라오게 처리
              onChanged: (value) {
                setState(() {
                  _inputValue = value;
                  if (_hasSubmitted && value.isNotEmpty) {
                    _hasSubmitted = false;
                  }
                });
              },
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              maxLength: 15,
              cursorColor: appColorScheme.primaryLight,
              cursorWidth: 1.0,
              cursorHeight: 18,
              style: appTextTheme.headlineSmallKo.copyWith(
                fontWeight: FontWeight.w400,
                color: appColorScheme.primaryLight,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: widget.categorySettingMode == CategorySettingMode.add
                    ? '카테고리 이름을 입력해 주세요'
                    : '변경할 카테고리 이름을 입력해 주세요',
                hintStyle: appTextTheme.headlineSmallKo.copyWith(
                  color: appColorScheme.textLight,
                  fontWeight: FontWeight.w300,
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
                        : appColorScheme.primaryLight,
                    width: .5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isError
                        ? appColorScheme.error
                        : appColorScheme.primaryLight,
                    width: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasSubmitted = true;
                  });
                  if (_inputValue.isEmpty) {
                    HapticFeedback.lightImpact(); ///입력창 비어있을때 저장 누르면 진동
                    return;
                  }
                  context.pop(_inputValue);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: appColorScheme.primaryLight,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  overlayColor: Colors.transparent,
                ),
                child: Text(
                  '저장',
                  style: appTextTheme.bodyMedium.copyWith(
                    color: appColorScheme.primaryDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            _focusNode.hasFocus
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox(
                    height: 40,
                  ),
          ],
        ),
      ),
    );
  }
}
