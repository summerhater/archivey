import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';

class SignInCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String guide;
  final bool? isPassword;

  const SignInCustomTextField({super.key, required this.controller, required this.guide, this.isPassword});

  @override
  State<SignInCustomTextField> createState() => _SignInCustomTextFieldState();
}

class _SignInCustomTextFieldState extends State<SignInCustomTextField> {
  late final TextEditingController controller;
  late final String guide;
  late final bool isPassword;

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    guide = widget.guide;
    isPassword = widget.isPassword ?? false;


  }

  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return TextField(

      controller: controller,
      decoration: InputDecoration(
        labelText: guide,
        labelStyle: appText.bodySmall.copyWith(
          color: appColor.textLight,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appColor.strokeLight,
            width: .5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appColor.strokeLight,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appColor.strokeLight,
          ),
        ),
        suffixIcon: isPassword ? IconButton(
          onPressed: () {
            setState(() {
              visibility = !visibility;
            });
          },
          icon: Icon(
            visibility
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
            color: appColor.textLight,
          ),
        ) : IconButton(onPressed: () {
          controller.clear();
        }, icon: Icon(
          Icons.close,
          color: appColor.textLight,
        )),
      ),
      cursorColor: appColor.textLight,
      style: appText.bodySmall.copyWith(
        color: appColor.textLight,
      ),
      obscureText: isPassword && !visibility,
    );
  }
}
