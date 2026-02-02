import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class DocumentDetailMemoWidget extends StatelessWidget {
  final bool isEditing;
  final String? memo;
  final TextEditingController controller;
  final FocusNode focusNode;

  const DocumentDetailMemoWidget({
    super.key,
    required this.isEditing,
    required this.memo,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    if (isEditing) {
      return Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 10,
            maxLength: 200,
            cursorColor: appColorScheme.categoryTagBg,
            cursorWidth: 1.0,
            cursorHeight: 18,
            magnifierConfiguration: TextMagnifierConfiguration.disabled,
            style: appTextTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w300,
              color: appColorScheme.textDark,
              height: 1.6,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: appColorScheme.documentDetailBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: '메모를 입력하세요..',
              hintStyle: appTextTheme.bodySmall.copyWith(
                color: appColorScheme.textLight,
              ),
            ),
          ),
        ],
      );
    }

    // return Center(
    //   child: Text(
    //     (memo?.isEmpty ?? true) ? '저장된 메모가 아직 없어요 📝' : memo!,
    //     style: appTextTheme.bodySmall.copyWith(
    //       fontWeight: FontWeight.w500,
    //       color: appColorScheme.textLight,
    //       height: 1.6,
    //     ),
    //   ),
    // );
    final bool isEmpty = memo?.isEmpty ?? true;

    return isEmpty
        ? Center(
      child: Text(
        '저장된 메모가 아직 없어요 📝',
        style: appTextTheme.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: appColorScheme.textLight,
          height: 1.6,
        ),
      ),
    )
        : Text(
      memo!,
      style: appTextTheme.bodySmall.copyWith(
        fontWeight: FontWeight.w300,
        color: appColorScheme.textDark,
        height: 1.6,
      ),
    );
  }
}