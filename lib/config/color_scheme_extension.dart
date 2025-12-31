import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color textDark;
  final Color textLight;

  final Color primary;
  final Color primaryStrong;

  final Color searchBackground;

  final Color error;
  final Color errorBg;

  final Color strokeLight;

  final Color snackBarBg;
  final Color categoryTagBg;
  final Color documentDetailBg;

  const AppColorScheme({
    this.textDark = const Color(0xFF333333),
    this.textLight = const Color(0xFFAEAEAE),
    this.primary = const Color(0xFFFFFFFF),
    this.primaryStrong = const Color(0xFF111111),
    this.searchBackground = const Color(0xFFE8E8E8),
    this.error = const Color(0xFFED7A7A),
    this.errorBg = const Color(0xFFFFE8E6),
    this.strokeLight = const Color(0xFFDDDDDD),
    this.snackBarBg = const Color(0xFF444444),
    this.categoryTagBg = const Color(0xFF6A6A6A),
    this.documentDetailBg = const Color(0xFFF5F5F5),
  });

  @override
  ThemeExtension<AppColorScheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  AppColorScheme lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;

    return AppColorScheme(
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryStrong: Color.lerp(primaryStrong, other.primaryStrong, t)!,
      searchBackground: Color.lerp(
        searchBackground,
        other.searchBackground,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      strokeLight: Color.lerp(strokeLight, other.strokeLight, t)!,
      snackBarBg: Color.lerp(snackBarBg, other.snackBarBg, t)!,
      categoryTagBg: Color.lerp(categoryTagBg, other.categoryTagBg, t)!,
      documentDetailBg: Color.lerp(
        documentDetailBg,
        other.documentDetailBg,
        t,
      )!,
    );
  }
}
