import 'package:archivey/ui/setting/widget/build_setting_menu_item_widget.dart';
import 'package:archivey/ui/setting/widget/delete_account_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/color_scheme_extension.dart';
import '../../config/text_theme_extension.dart';
import '../document/widget/app_toggle_switch_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String email = 'user@example.com';
  bool isLoggedIn = true;
  bool aiSummaryEnabled = true;

  void _handleLogout() {
    ///todo: 로그아웃 로직 여기에
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '설정',
                          style: appTextTheme.headlineLargeKo.copyWith(
                            fontWeight: FontWeight.bold,
                            color: appColorScheme.textDark,
                          ),
                        ),
                        SizedBox(height: 30),

                        /// 계정 정보 (프로필)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: appColorScheme.primaryDark,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '이메일',
                                      style: appTextTheme.bodyMedium.copyWith(
                                        color: appColorScheme.textLight,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      email,
                                      style: appTextTheme.bodySmall.copyWith(
                                        color: appColorScheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            isLoggedIn
                                ? OutlinedButton.icon(
                                    onPressed: _handleLogout,
                                    icon: Icon(Icons.logout),
                                    label: Text(
                                      '로그아웃',
                                      style: appTextTheme.bodySmall.copyWith(
                                        color: appColorScheme.textDark,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          appColorScheme.primaryDark,
                                      side: BorderSide(
                                        color: appColorScheme.strokeLight,
                                      ),
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.mail),
                                    label: Text('이메일로 로그인'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          appColorScheme.primaryDark,
                                      foregroundColor:
                                          appColorScheme.primaryLight,
                                    ),
                                  ),
                          ],
                        ),
                        Divider(height: 48, color: appColorScheme.strokeLight),

                        /// AI 요약 설정 토글 스위치
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI 요약',
                                    style: appTextTheme.bodyMedium.copyWith(
                                      color: appColorScheme.primaryDark,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '수집한 콘텐츠를 AI로 자동 요약합니다.',
                                    style: appTextTheme.bodySmall.copyWith(
                                      color: appColorScheme.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppToggleSwitchWidget(
                              value: aiSummaryEnabled,
                              onChanged: (value) {
                                setState(() {
                                  aiSummaryEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(height: 48, color: appColorScheme.strokeLight),
                        SettingMenuItemWidget(
                          icon: Icons.notifications,
                          label: '공지사항',
                          onTap: () {},
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                        ),

                        SettingMenuItemWidget(
                          icon: Icons.mail,
                          label: '문의하기',
                          onTap: () {},
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                        ),

                        SettingMenuItemWidget(
                          icon: Icons.code,
                          label: '앱 버전',
                          onTap: () {},
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                          suffix: Row(
                            children: [
                              Text(
                                '1.0.0',
                                style: appTextTheme.bodySmall.copyWith(
                                  color: appColorScheme.primaryDark,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),

                        SettingMenuItemWidget(
                          label: '탈퇴하기',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => DeleteAccountDialogWidget(),
                            );
                          },
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                        ),
                        Text(
                          'ⓒ 2025 archivey All rights reserved.',
                          style: appTextTheme.labelMedium.copyWith(
                            color: appColorScheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
