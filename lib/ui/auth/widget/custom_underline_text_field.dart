import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';

class CustomUnderlineTextField extends StatefulWidget {
  final void Function(String)? getText;
  final String hintText;
  final bool? isPassword;

  const CustomUnderlineTextField({
    super.key,
    this.getText,
    required this.hintText,
    this.isPassword,
  });

  @override
  State<CustomUnderlineTextField> createState() => _CustomUnderlineTextFieldState();
}

class _CustomUnderlineTextFieldState extends State<CustomUnderlineTextField> {

  final TextEditingController _controller = TextEditingController();
  late final String hintText;
  late final bool isPassword;

  late bool isGetText;

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    hintText = widget.hintText;
    isPassword = widget.isPassword ?? false;
    isGetText = widget.getText != null;
  }
  @override
  void dispose() {
    _controller.dispose();
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
          borderSide: BorderSide(color: appColor.primaryStrong, width: .5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.primaryStrong, width: 1),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.primaryStrong, width: 1),
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
      onChanged: isGetText ? (value) => widget.getText!(value) : null,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      cursorColor: appColor.primaryStrong,
      style: appText.bodyMedium.copyWith(
        color: appColor.primaryStrong,
      ),
      obscureText: isPassword && !visibility,
    );
  }
}
