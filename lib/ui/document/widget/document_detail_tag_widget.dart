import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';

class DocumentDetailTagWidget extends StatelessWidget {
  final bool isEditing;
  final List<String> tags;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onTagDeleted;
  final Function(String) onTagAdded;

  const DocumentDetailTagWidget({
    super.key,
    required this.isEditing,
    required this.tags,
    required this.controller,
    required this.focusNode,
    required this.onTagDeleted,
    required this.onTagAdded,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: appColorScheme.searchBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: appTextTheme.labelLarge.copyWith(
                        color: appColorScheme.categoryTagBg,
                      ),
                    ),
                    if (isEditing) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => onTagDeleted(tag),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: appColorScheme.categoryTagBg,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (isEditing) ...[
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            cursorColor: appColorScheme.categoryTagBg,
            cursorWidth: 1.0,
            cursorHeight: 18,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onTagAdded(value);
              } else {
                focusNode.unfocus();
              }
            },
            decoration: InputDecoration(
              hintText: '태그를 입력해 주세요..',
              hintStyle: appTextTheme.bodySmall.copyWith(
                color: appColorScheme.textLight,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ],
    );
  }
}