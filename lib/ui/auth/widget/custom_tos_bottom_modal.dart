import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTosBottomModal extends StatefulWidget {
  final String path;

  const CustomTosBottomModal({super.key, required this.path});

  @override
  State<CustomTosBottomModal> createState() => _CustomTosBottomModalState();
}

class _CustomTosBottomModalState extends State<CustomTosBottomModal> {
  late final String path;

  @override
  void initState() {
    super.initState();
    path = widget.path;
  }

  bool checkAll = false;

  List<bool> checkList = [
    false,
    false,
  ];

  List<String> checkGuide = [
    '서비스 이용 약관 (필수)',
    '개인약관처리방침 (필수)',
  ];

  List<bool> guideDetail = [
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return Padding(
      padding: EdgeInsetsGeometry.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '아카이비 이용을 위해\n',
                  style: TextStyle(
                    fontSize: appText.bodyLarge.fontSize,
                    color: appColor.primaryDark,
                  ),
                ),
                TextSpan(
                  text: '동의',
                  style: TextStyle(
                    fontSize: appText.bodyLarge.fontSize,
                    color: appColor.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '가 필요해요.',
                  style: TextStyle(
                    fontSize: appText.bodyLarge.fontSize,
                    color: appColor.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                checkAll = !checkAll;
                for (int i = 0; i < checkList.length; i++) {
                  checkList[i] = checkAll;
                }
              });
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.check,
                    size: appText.headlineSmallEn.fontSize,
                    color: checkAll
                        ? appColor.primaryDark
                        : appColor.strokeLight,
                  ),
                ),
                Text(
                  '모두 동의합니다.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appColor.primaryDark,
                    fontSize: appText.bodySmall.fontSize,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          for (int i = 0; i < checkList.length; i++) ...[
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checkList[i] = !checkList[i];
                          checkAll = checkList.every((e) => e);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // height: appText.headlineSmallEn.fontSize,
                        // width: appText.headlineSmallEn.fontSize,
                        child: Icon(
                          Icons.check,
                          size: appText.headlineSmallEn.fontSize,
                          color: checkList[i]
                              ? appColor.primaryDark
                              : appColor.strokeLight,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        guideDetail[i] = !guideDetail[i];
                      }),
                      child: Text(
                        checkGuide[i],
                        style: TextStyle(
                          color: appColor.primaryDark,
                          fontSize: appText.bodySmall.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                guideDetail[i] ? Text('임시용') : SizedBox(),
              ],
            ),
          ],
          Divider(
            color: Colors.transparent,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
            ),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: checkList.every((e) => e) ? () {
                context.go(path);
              } : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: appColor.primaryLight,
                  ),
                ),
                backgroundColor: appColor.primaryDark,
                padding: EdgeInsets.all(20),
              ),
              child: Text(
                '약관 동의 완료',
                style: TextStyle(
                  color: appColor.primaryLight,
                  fontSize: appText.bodyMedium.fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
