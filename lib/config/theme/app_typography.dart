import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/constants/my_string.dart';

abstract final class AppTypography {
  static TextTheme build(AppThemeColors colors) {
    TextStyle heading(
      double size, {
      FontWeight weight = FontWeight.w600,
      Color? color,
      double? height,
      double? letterSpacing,
    }) {
      final family = switch (weight) {
        FontWeight.w700 ||
        FontWeight.w800 ||
        FontWeight.w900 => MyString.poppinsBold,
        FontWeight.w500 || FontWeight.w600 => MyString.poppinsMedium,
        _ => MyString.poppinsRegular,
      };

      return TextStyle(
        fontFamily: family,
        fontSize: size.sp,
        fontWeight: weight,
        color: color ?? colors.textPrimary,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    TextStyle body(
      double size, {
      FontWeight weight = FontWeight.w400,
      Color? color,
      double? height,
      double? letterSpacing,
    }) {
      final family = weight.index >= FontWeight.w600.index
          ? MyString.rubikBold
          : weight == FontWeight.w500
          ? MyString.rubikMedium
          : MyString.rubikRegular;

      return TextStyle(
        fontFamily: family,
        fontSize: size.sp,
        fontWeight: weight,
        color: color ?? colors.textPrimary,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      displayLarge: heading(
        42,
        weight: FontWeight.w700,
        height: 1.08,
        letterSpacing: -1.2,
      ),
      displayMedium: heading(
        34,
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.8,
      ),
      displaySmall: heading(
        29,
        weight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.6,
      ),
      headlineLarge: heading(
        28,
        weight: FontWeight.w700,
        height: 1.16,
        letterSpacing: -0.5,
      ),
      headlineMedium: heading(
        25,
        weight: FontWeight.w700,
        height: 1.18,
        letterSpacing: -0.4,
      ),
      headlineSmall: heading(22, weight: FontWeight.w600, height: 1.2),
      titleLarge: heading(20, weight: FontWeight.w600, height: 1.25),
      titleMedium: heading(16, weight: FontWeight.w600, height: 1.3),
      titleSmall: heading(14, weight: FontWeight.w600, height: 1.3),
      bodyLarge: body(16, height: 1.5),
      bodyMedium: body(14, color: colors.textSecondary, height: 1.5),
      bodySmall: body(12, color: colors.textSecondary, height: 1.45),
      labelLarge: body(14, weight: FontWeight.w600, height: 1.25),
      labelMedium: body(
        12,
        weight: FontWeight.w600,
        color: colors.textSecondary,
        height: 1.25,
      ),
      labelSmall: body(
        10.5,
        weight: FontWeight.w600,
        color: colors.textMuted,
        height: 1.25,
        letterSpacing: 0.2,
      ),
    );
  }
}
