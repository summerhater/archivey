import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color textDark;
  final Color textLight;

  final Color primaryLight;
  final Color primaryDark;

  final Color searchBackground;

  final Color error;
  final Color errorBg;

  final Color strokeLight;

  final Color snackBarBg;

  const AppColorScheme({
    this.textDark = const Color(0xFF333333),
    this.textLight = const Color(0xFFAEAEAE),
    this.primaryLight = const Color(0xFFFFFFFF),
    this.primaryDark = const Color(0xFF111111),
    this.searchBackground = const Color(0xFFE8E8E8),
    this.error = const Color(0xFFED7A7A),
    this.errorBg = const Color(0xFFFFE8E6),
    this.strokeLight = const Color(0xFFDDDDDD),
    this.snackBarBg = const Color(0xFF444444),
  });

  @override
  ThemeExtension<AppColorScheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
