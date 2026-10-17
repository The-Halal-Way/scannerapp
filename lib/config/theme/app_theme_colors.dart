import 'package:flutter/material.dart';

/// Semantic colors that are not represented by Material's [ColorScheme].
///
/// Keeping these values in a [ThemeExtension] lets branded gradients, glass
/// surfaces, and status accents react to light and dark mode without leaking
/// palette decisions into feature widgets.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.stroke,
    required this.strokeStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.brand,
    required this.violet,
    required this.cyan,
    required this.coral,
    required this.success,
    required this.warning,
    required this.danger,
    required this.heroStart,
    required this.heroMiddle,
    required this.heroEnd,
    required this.heroForeground,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color stroke;
  final Color strokeStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color brand;
  final Color violet;
  final Color cyan;
  final Color coral;
  final Color success;
  final Color warning;
  final Color danger;
  final Color heroStart;
  final Color heroMiddle;
  final Color heroEnd;
  final Color heroForeground;
  final Color shadow;

  static const light = AppThemeColors(
    canvas: Color(0xFFF6F7FC),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFCFCFF),
    surfaceMuted: Color(0xFFF0F2FA),
    stroke: Color(0xFFE2E5F0),
    strokeStrong: Color(0xFFCCD1E0),
    textPrimary: Color(0xFF15182B),
    textSecondary: Color(0xFF59627A),
    textMuted: Color(0xFF8A93AA),
    brand: Color(0xFF625BF6),
    violet: Color(0xFF8B5CF6),
    cyan: Color(0xFF08AFCB),
    coral: Color(0xFFE94D8C),
    success: Color(0xFF168F68),
    warning: Color(0xFFC67A05),
    danger: Color(0xFFD43D55),
    heroStart: Color(0xFF11163F),
    heroMiddle: Color(0xFF352777),
    heroEnd: Color(0xFF6848E8),
    heroForeground: Color(0xFFFFFFFF),
    shadow: Color(0xFF202650),
  );

  static const dark = AppThemeColors(
    canvas: Color(0xFF080A15),
    surface: Color(0xFF101426),
    surfaceElevated: Color(0xFF171B31),
    surfaceMuted: Color(0xFF1D233B),
    stroke: Color(0xFF29304D),
    strokeStrong: Color(0xFF3A4366),
    textPrimary: Color(0xFFF4F5FF),
    textSecondary: Color(0xFFB2BAD2),
    textMuted: Color(0xFF7F89A8),
    brand: Color(0xFF8C86FF),
    violet: Color(0xFFA983FF),
    cyan: Color(0xFF47D7EC),
    coral: Color(0xFFFF79AE),
    success: Color(0xFF4FD5A3),
    warning: Color(0xFFFFC766),
    danger: Color(0xFFFF7184),
    heroStart: Color(0xFF0D1233),
    heroMiddle: Color(0xFF2A225F),
    heroEnd: Color(0xFF5136B7),
    heroForeground: Color(0xFFFFFFFF),
    shadow: Color(0xFF000000),
  );

  @override
  AppThemeColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceMuted,
    Color? stroke,
    Color? strokeStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? brand,
    Color? violet,
    Color? cyan,
    Color? coral,
    Color? success,
    Color? warning,
    Color? danger,
    Color? heroStart,
    Color? heroMiddle,
    Color? heroEnd,
    Color? heroForeground,
    Color? shadow,
  }) {
    return AppThemeColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      stroke: stroke ?? this.stroke,
      strokeStrong: strokeStrong ?? this.strokeStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      brand: brand ?? this.brand,
      violet: violet ?? this.violet,
      cyan: cyan ?? this.cyan,
      coral: coral ?? this.coral,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      heroStart: heroStart ?? this.heroStart,
      heroMiddle: heroMiddle ?? this.heroMiddle,
      heroEnd: heroEnd ?? this.heroEnd,
      heroForeground: heroForeground ?? this.heroForeground,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppThemeColors lerp(covariant AppThemeColors? other, double t) {
    if (other == null) return this;
    return AppThemeColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      strokeStrong: Color.lerp(strokeStrong, other.strokeStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroMiddle: Color.lerp(heroMiddle, other.heroMiddle, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      heroForeground: Color.lerp(heroForeground, other.heroForeground, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors {
    final theme = Theme.of(this);
    return theme.extension<AppThemeColors>() ??
        (theme.brightness == Brightness.dark
            ? AppThemeColors.dark
            : AppThemeColors.light);
  }
}
