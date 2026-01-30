import 'package:archivey/ui/setting/view_model/setting_view_model.dart';
import 'package:archivey/ui/setting/widget/build_setting_menu_item_widget.dart';
import 'package:archivey/ui/setting/widget/delete_account_dialog_widget.dart';
import 'package:archivey/ui/setting/widget/re_authentication_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/color_scheme_extension.dart';
import '../../config/text_theme_extension.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String email = 'user@example.com';
  bool isLoggedIn = true;
  bool aiSummaryEnabled = true;
  String? appVersion;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    if (Provider.of<SettingViewModel>(context, listen: false).email.isEmpty) {
      isLoggedIn = false;
    }
  }

  void _handleLogout() {
    Provider.of<SettingViewModel>(context, listen: false).logout().then((_) {
      setState(() {
        isLoggedIn = false;
      });
    });
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final vm = context.read<SettingViewModel>();
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
                            fontWeight: FontWeight.w600,
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
                                    color: appColorScheme.primaryStrong,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                SizedBox(width: 16),
                                isLoggedIn
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '이메일',
                                            style: appTextTheme.bodyMedium
                                                .copyWith(
                                                  color:
                                                      appColorScheme.textLight,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            vm.email,
                                            style: appTextTheme.bodySmall
                                                .copyWith(
                                                  color:
                                                      appColorScheme.textDark,
                                                ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '로그인을 해주세요',
                                        style: appTextTheme.bodyMedium.copyWith(
                                          color: appColorScheme.textDark,
                                        ),
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
                                          appColorScheme.primaryStrong,
                                      side: BorderSide(
                                        color: appColorScheme.strokeLight,
                                      ),
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () {
                                      context.go('/auth/sign-in');
                                    },
                                    icon: Icon(Icons.mail),
                                    label: Text('이메일로 로그인'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          appColorScheme.primaryStrong,
                                      foregroundColor: appColorScheme.primary,
                                    ),
                                  ),
                          ],
                        ),
                        Divider(height: 48, color: appColorScheme.strokeLight),
                        SettingMenuItemWidget(
                          icon: Icons.notifications,
                          label: '공지사항',
                          onTap: () async {
                            final url =
                                'https://www.notion.so/archivey-2e6299c18862802a91ddcc7dce6f10b0?source=copy_link';
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                        ),

                        Divider(height: 48, color: appColorScheme.strokeLight),

                        SettingMenuItemWidget(
                          icon: Icons.mail,
                          label: '문의하기',
                          onTap: () async {
                            final url = 'https://forms.gle/aPeFzWGP4mVna1eZ8';
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                        ),

                        Divider(height: 48, color: appColorScheme.strokeLight),

                        SettingMenuItemWidget(
                          icon: Icons.code,
                          label: '앱 버전',
                          onTap: null,
                          appTextTheme: appTextTheme,
                          appColorScheme: appColorScheme,
                          suffix: Row(
                            children: [
                              Text(
                                appVersion ?? '버전 정보 로드 실패',
                                style: appTextTheme.bodySmall.copyWith(
                                  color: appColorScheme.primaryStrong,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),

                        Divider(height: 48, color: appColorScheme.strokeLight),

                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              size: 20,
                              color: appColorScheme.primaryStrong,
                            ),
                            SizedBox(width: 12),
                            Text(
                              '약관 및 정책',
                              style: appTextTheme.bodyMedium.copyWith(
                                color: appColorScheme.primaryStrong,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Column(
                            children: [
                              SettingMenuItemWidget(
                                label: '서비스 이용약관',
                                onTap: () async {
                                  final url =
                                      'https://gigantic-sycamore-e89.notion.site/2f860523334d80169aeef60c7554c56f?pvs=74';
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                appTextTheme: appTextTheme,
                                appColorScheme: appColorScheme,
                                isSubWidget: true,
                              ),
                              SettingMenuItemWidget(
                                label: '개인정보 처리방침',
                                onTap: () async {
                                  final url =
                                      'https://gigantic-sycamore-e89.notion.site/2f860523334d80c69cd9e72ba72603c0?pvs=74';
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                appTextTheme: appTextTheme,
                                appColorScheme: appColorScheme,
                                isSubWidget: true,
                              ),
                              SettingMenuItemWidget(
                                label: '라이선스',
                                onTap: () {
                                  // showLicensePage(
                                  //   context: context,
                                  //   applicationName: 'Archivey',
                                  //   applicationVersion: appVersion,
                                  //   applicationLegalese: 'ⓒ 2026 archivey All rights reserved.',
                                  //   useRootNavigator: true,
                                  // );
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => Theme(
                                        data: Theme.of(context).copyWith(
                                          scaffoldBackgroundColor:
                                              appColorScheme.primary,
                                          appBarTheme: AppBarTheme(
                                            backgroundColor:
                                                appColorScheme.primary,
                                            scrolledUnderElevation: 0,
                                            elevation: 0,
                                          ),
                                          cardColor:
                                              appColorScheme.documentDetailBg,
                                        ),
                                        child: LicensePage(
                                          applicationName: 'Archivey',
                                          applicationVersion: appVersion,
                                          applicationLegalese:
                                              'ⓒ 2026 archivey All rights reserved.',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                isSubWidget: true,
                                appTextTheme: appTextTheme,
                                appColorScheme: appColorScheme,
                              ),
                            ],
                          ),
                        ),

                        Divider(height: 48, color: appColorScheme.strokeLight),

                        if (isLoggedIn) ...[
                          SettingMenuItemWidget(
                            label: '탈퇴하기',
                            onTap: () async {
                              final bool? reAuth = await showDialog(
                                context: context,
                                builder: (context) =>
                                    ReAuthenticationDialogWidget(
                                      reAuthentication: vm.reAuthentication,
                                      deleteAccount: () async =>
                                          await vm.deleteAccount(),
                                    ),
                              );
                              if (reAuth == null || !reAuth) return;
                              final bool? deleteAccount = await showDialog(
                                context: context,
                                builder: (context) => DeleteAccountDialogWidget(
                                  deleteAccount: () async =>
                                      await vm.deleteAccount(),
                                ),
                              );
                              if (deleteAccount == null || !deleteAccount)
                                return;
                              print('###### 탈퇴 성공 후, auth로 이동');
                              // TODO auth로 안감 해결 해야 함
                              // GoRouter.of(context).go('/auth');
                            },
                            appTextTheme: appTextTheme,
                            appColorScheme: appColorScheme,
                          ),
                          Divider(
                            height: 48,
                            color: appColorScheme.strokeLight,
                          ),
                        ],
                        Text(
                          'ⓒ 2026 archivey All rights reserved.',
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
