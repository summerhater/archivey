import 'dart:io';

import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/auth/widget/custom_tos_bottom_modal.dart';
import 'package:archivey/ui/auth/widget/custom_elevated_button.dart';
import 'package:archivey/ui/auth/widget/sign_in_custom_text_button.dart';
import 'package:archivey/ui/auth/widget/sign_in_custom_text_field.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:archivey/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool isIosMobile = !kIsWeb && Platform.isIOS;
  bool pwVisibility = false;

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DismissKeyboard(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/archivey_background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.only(top: 25, right: 25, left: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.heightOf(context) * 0.45,
                      child: SvgPicture.asset('assets/icons/archivey_white.svg',
                        width: MediaQuery.widthOf(context) * 0.5,),
                    ),
                    SignInCustomTextField(
                      controller: _emailController,
                      guide: '이메일',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SignInCustomTextField(
                      controller: _pwController,
                      guide: '패스워드',
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomElevatedButton(
                      path: '/document_all_index',
                      guide: '로그인',
                      backgroundColor: appColor.primaryStrong,
                      fontSize: appText.bodyMedium.fontSize,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        try {
                          await context
                              .read<AuthViewModel>()
                              .signInWithEmailAndPassword(
                              email: _emailController.text,
                              pw: _pwController.text);

                          if (!context.mounted) return;
                          context.go('/document_all_index');
                        } on FirebaseAuthException catch (e) {
                          if(!context.mounted) return;

                          if(e.code == 'email-not-verified') {
                            context.showAppMessageSnackBar(e.message!);
                            context.go('/auth/signup-email/signup-password/signup-email-verify');
                            return;
                          }
                          context.showAppMessageSnackBar(e.message ?? '로그인 오류');
                        }catch(e) {
                          if(!context.mounted) return;
                          context.showAppMessageSnackBar(e.toString());
                        }
                      },
                      // => await context
                      //     .read<AuthViewModel>()
                      //     .signInWithEmailAndPassword(
                      //       email: _emailController.text.trim(),
                      //       pw: _pwController.text,
                      //     )
                      //     .then((value) {
                      //       if (!context.mounted) return;
                      //       context.go('/document_all_index');
                      //     })
                      //     .catchError((e) {
                      //       if (!context.mounted) return;
                      //       context.showAppMessageSnackBar(e.toString());
                      //     }),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SignInCustomTextButton(
                            path: '/auth/sign-in/find',
                            guide: '아이디 / 비밀번호 찾기',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: appText.labelLarge.fontSize,
                            child: VerticalDivider(
                              // TODO 트러블 슈팅 -> 세로 구분선은 범위를 지정해 줘야 함 ex. sizedbox, container
                              color: appColor.primary,
                              width: 10,
                              thickness: .5,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SignInCustomTextButton(
                            path: '/auth/signup-email',
                            guide: '이메일 가입하기',
                            asyncFunction: () async => await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => CustomTosBottomModal(
                                path: '/auth/signup-email',
                              ), // TODO Modal창 문서화?
                              backgroundColor: appColor.primary,
                              useSafeArea: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
