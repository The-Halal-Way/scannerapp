import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/constants/my_string.dart';

abstract final class AppTypography {
  static TextTheme build(AppThemeColors colors) {
    TextStyle style(
      double size, {
      FontWeight weight = FontWeight.w400,
      Color? color,
      double? height,
      double? letterSpacing,
    }) => TextStyle(
      fontFamily: MyString.appFont,
      fontSize: size.sp,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
      color: color ?? colors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );

    return TextTheme(
      displayLarge: style(
        38,
        weight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.4,
      ),
      displayMedium: style(
        32,
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacing: -1.1,
      ),
      displaySmall: style(
        28,
        weight: FontWeight.w800,
        height: 1.16,
        letterSpacing: -.9,
      ),
      headlineLarge: style(
        27,
        weight: FontWeight.w800,
        height: 1.16,
        letterSpacing: -.8,
      ),
      headlineMedium: style(
        24,
        weight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -.6,
      ),
      headlineSmall: style(
        21,
        weight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -.4,
      ),
      titleLarge: style(
        19,
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -.3,
      ),
      titleMedium: style(
        16,
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -.2,
      ),
      titleSmall: style(14, weight: FontWeight.w700, height: 1.3),
      bodyLarge: style(16, height: 1.48),
      bodyMedium: style(14, color: colors.textSecondary, height: 1.48),
      bodySmall: style(12, color: colors.textSecondary, height: 1.45),
      labelLarge: style(14, weight: FontWeight.w700, height: 1.25),
      labelMedium: style(
        12,
        weight: FontWeight.w700,
        color: colors.textSecondary,
        height: 1.25,
      ),
      labelSmall: style(
        10.5,
        weight: FontWeight.w700,
        color: colors.textMuted,
        height: 1.25,
        letterSpacing: .1,
      ),
    );
  }
}
