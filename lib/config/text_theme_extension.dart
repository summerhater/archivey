import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle headlineSmallEn;
  final TextStyle headlineSmallKo;

  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  const AppTextTheme({
    this.headlineSmallEn = const TextStyle(
      fontFamily: 'theseasons',
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ), ///all_page - index(영문)
    this.headlineSmallKo = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),///all_page - 전체(국문)
    this.bodyLarge = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 18,
    ),///회원가입 페이지
    this.bodyMedium = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 14,
    ),///바텀시트, vertical tab navigation 등
    this.bodySmall = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 12,
    ),///카테고리 수집물 갯수 디스플레이, AI요약 본문 등
    this.labelLarge = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 10,
    ),///회원가입 페이지네이션, 검색창 placeholder 등
    this.labelMedium = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 9,
    ),///리스트 저장 날짜, 수집물 갯수 등
    this.labelSmall = const TextStyle(
      fontFamily: 'scDream',
      fontSize: 8,
    ),///리스트 태그
  });

  @override
  AppTextTheme copyWith({
    TextStyle? headlineSmallEn,
    TextStyle? headlineSmallKo,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return AppTextTheme(
      headlineSmallEn: headlineSmallEn ?? this.headlineSmallEn,
      headlineSmallKo: headlineSmallKo ?? this.headlineSmallKo,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  AppTextTheme lerp(
      covariant ThemeExtension<AppTextTheme>? other,
      double t,
      ) {
    if (other is! AppTextTheme) return this;

    return AppTextTheme(
      headlineSmallEn: TextStyle.lerp(headlineSmallEn, other.headlineSmallEn, t)!,
      headlineSmallKo: TextStyle.lerp(headlineSmallKo, other.headlineSmallKo, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }
}
