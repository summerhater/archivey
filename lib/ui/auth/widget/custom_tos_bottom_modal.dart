import 'dart:io';

import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
    false,
  ];

  List<String> checkGuide = [
    '서비스 이용약관 (필수)',
    '개인정보 처리방침 (필수)',
    '만 14세 이상입니다. (필수)',
  ];

  List<bool> guideDetail = [
    false,
    false,
    false,
  ];

  List<String> guideText = [
    '''
서비스 이용을 위해 아래 핵심 내용을 확인해 주세요.

- 서비스 목적: 이용자가 콘텐츠를 저장, 관리하고 공유할 수 있는 기능을 제공합니다.

- 콘텐츠 권리: 회원이 업로드한 콘텐츠의 저작권은 회원에게 있습니다. 단, 운영자는 서비스 운영(저장, 복제, 전송 등)을 위해 필요한 범위 내에서 이를 이용할 수 있습니다.

- 회원의 의무: 타인의 계정 도용, 저작권 침해, 불법 콘텐츠 게시 등을 금지하며, 위반 시 서비스 이용이 제한될 수 있습니다.

- 면책 사항: 천재지변, 시스템 장애, 또는 회원의 귀책사유로 발생한 손해에 대해 운영자는 고의·중과실이 없는 한 책임을 지지 않습니다.

- 유료화 가능성: 현재 서비스는 무료이나, 향후 유료 기능 도입 시 사전에 상세히 공지하며 회원의 동의 없이 자동 과금되지 않습니다.
''',
    '''
아카이비 개인정보처리방침 요약

아카이비는 이용자의 개인정보를 소중히 보호하며, 관련 법령을 준수합니다.

- 수집 항목: 이메일 주소, 비밀번호, 기기 정보(OS, 브라우저), 접속 로그, 서비스 이용 기록.

- 이용 목적: 회원 식별 및 로그인, 계정 보안 관리, 서비스 기능 제공 및 개선, 고객 문의 응대.

- 보유 및 이용 기간: 회원 탈퇴 시 즉시 파기.
단, 법령에 따라 로그 기록은 3개월, 분쟁 처리 기록은 3년간 보관합니다.

- 개인정보 국외 이전: 서비스의 안정적인 운영을 위해 Google(Firebase)의 국외 서버(미국 등)를 이용하며 데이터가 안전하게 전송·저장됩니다.

- 동의 거부 권리: 귀하는 개인정보 수집 동의를 거부할 수 있으나, 거부 시 회원가입 및 서비스 이용이 불가능합니다.
    ''',
  ];

  List<String> guideURL = [
    'https://gigantic-sycamore-e89.notion.site/2f860523334d80169aeef60c7554c56f?pvs=74',
    'https://gigantic-sycamore-e89.notion.site/2f860523334d80c69cd9e72ba72603c0?pvs=74',
  ];

  bool isIosMobile = !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;


    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      bottom: !isIosMobile,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 타이틀
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '아카이비 이용을 위해\n',
                        style: appText.bodyLarge.copyWith(
                          color: appColor.primaryStrong,
                        ),
                      ),
                      TextSpan(
                        text: '동의',
                        style: appText.bodyLarge.copyWith(
                          color: appColor.primaryStrong,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '가 필요해요.',
                        style: appText.bodyLarge.copyWith(
                          color: appColor.primaryStrong,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 전체 동의 버튼
                GestureDetector(
                  onTap: () {
                    setState(() {
                      checkAll = !checkAll;
                      for (int i = 0; i < checkList.length; i++) {
                        checkList[i] = checkAll;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: appText.headlineSmallEn.fontSize,
                          color: checkAll
                              ? appColor.primaryStrong
                              : appColor.strokeLight,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '모두 동의합니다.',
                          style: appText.bodyMedium.copyWith(
                            color: appColor.primaryStrong,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: appColor.strokeLight, thickness: 0.5),
                const SizedBox(height: 10),

                // 개별 약관 리스트
                for (int i = 0; i < checkList.length; i++) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 체크박스 + 텍스트 (터치 시 체크 토글)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  checkList[i] = !checkList[i];
                                  checkAll = checkList.every((e) => e);
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: appText.bodyLarge.fontSize,
                                      color: checkList[i]
                                          ? appColor.primaryStrong
                                          : appColor.strokeLight,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        checkGuide[i],
                                        style: appText.bodySmall.copyWith(
                                          color: appColor.primaryStrong,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 우측 버튼 (요약보기, 전체보기)
                          if (i < 2)
                            Row(
                              children: [
                                // 요약보기 버튼
                                GestureDetector(
                                  onTap: () => setState(() {
                                    guideDetail[i] = !guideDetail[i];
                                  }),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '요약',
                                      style: appText.bodySmall.copyWith(
                                        color: appColor.primaryStrong,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                // 전체보기 버튼 (외부 링크)
                                GestureDetector(
                                  onTap: () async {
                                    final url = guideURL[i];
                                    final uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '전체',
                                      style: appText.bodySmall.copyWith(
                                        color: appColor.primaryStrong,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      // 요약 내용 표시 영역
                      if (guideDetail[i])
                        Container(
                          margin: const EdgeInsets.only(left: 30, top: 5, bottom: 15),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: appColor.documentDetailBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              guideText[i],
                              style: appText.labelMedium.copyWith(
                                color: appColor.primaryStrong,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // 완료 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkList.every((e) => e)
                        ? () {
                      Navigator.pop(context);
                      context.go(path);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: appColor.primaryStrong,
                      disabledBackgroundColor: appColor.strokeLight,
                      padding: const EdgeInsets.all(20),
                      elevation: 0,
                    ),
                    child: Text(
                      '약관 동의 완료',
                      style: appText.bodyMedium.copyWith(
                        color: checkList.every((e) => e)
                            ? appColor.primary
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}