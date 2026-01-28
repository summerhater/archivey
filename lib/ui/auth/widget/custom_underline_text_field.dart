import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';

class CustomUnderlineTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? isPassword;

  const CustomUnderlineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword,
  });

  @override
  State<CustomUnderlineTextField> createState() => _CustomUnderlineTextFieldState();
}

class _CustomUnderlineTextFieldState extends State<CustomUnderlineTextField> {

  late final TextEditingController _controller;
  late final String hintText;
  late final bool isPassword;

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    hintText = widget.hintText;
    isPassword = widget.isPassword ?? false;
  }
  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColorScheme>()!;
    var appText = Theme.of(context).extension<AppTextTheme>()!;

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintStyle: appText.bodyMedium.copyWith(
          color: appColor.textLight,
        ),
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.primaryStrong),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.primaryStrong),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.primaryStrong),
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
        )
        : null,
      ),
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      cursorColor: appColor.primaryStrong,
      style: appText.bodyMedium.copyWith(
        color: appColor.primaryStrong,
      ),
      obscureText: isPassword && !visibility,
    );
  }
}
