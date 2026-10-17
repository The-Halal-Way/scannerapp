import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_component_themes.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/config/theme/app_typography.dart';

abstract final class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1200;
  }

  static double responsiveTextScale(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 0.92;
    return 1.08;
  }

  static double responsiveSpacing(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 0.95;
    return 1.15;
  }

  static double tabletSizeMultiplier(BuildContext context) {
    return isTablet(context) ? 0.92 : 1;
  }

  static double getResponsiveSize(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }

  static double getResponsiveTextSize(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    return getResponsiveSize(context, mobileSize, tabletSize, desktopSize);
  }

  static ThemeData light(BuildContext context) {
    return _build(context, AppThemeColors.light, Brightness.light);
  }

  static ThemeData dark(BuildContext context) {
    return _build(context, AppThemeColors.dark, Brightness.dark);
  }

  static ThemeData _build(
    BuildContext context,
    AppThemeColors colors,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.brand,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          primary: colors.brand,
          onPrimary: Colors.white,
          primaryContainer: colors.brand.withValues(
            alpha: isDark ? 0.22 : 0.12,
          ),
          onPrimaryContainer: isDark ? colors.brand : const Color(0xFF28227A),
          secondary: colors.violet,
          onSecondary: Colors.white,
          secondaryContainer: colors.violet.withValues(
            alpha: isDark ? 0.22 : 0.12,
          ),
          onSecondaryContainer: isDark
              ? colors.violet
              : const Color(0xFF3E216C),
          tertiary: colors.cyan,
          onTertiary: const Color(0xFF001F25),
          tertiaryContainer: colors.cyan.withValues(alpha: isDark ? 0.2 : 0.12),
          onTertiaryContainer: colors.cyan,
          error: colors.danger,
          onError: Colors.white,
          errorContainer: colors.danger.withValues(alpha: isDark ? 0.2 : 0.1),
          onErrorContainer: colors.danger,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          onSurfaceVariant: colors.textSecondary,
          surfaceContainerLowest: colors.canvas,
          surfaceContainerLow: colors.surface,
          surfaceContainer: colors.surfaceElevated,
          surfaceContainerHigh: colors.surfaceMuted,
          surfaceContainerHighest: colors.surfaceMuted,
          outline: colors.strokeStrong,
          outlineVariant: colors.stroke,
          shadow: colors.shadow,
          scrim: Colors.black,
          inverseSurface: isDark
              ? AppThemeColors.light.surface
              : colors.textPrimary,
          onInverseSurface: isDark
              ? AppThemeColors.light.textPrimary
              : colors.surface,
          inversePrimary: isDark
              ? AppThemeColors.light.brand
              : AppThemeColors.dark.brand,
          surfaceTint: Colors.transparent,
        );

    final textTheme = AppTypography.build(colors);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      visualDensity: visualDensity,
      colorScheme: colorScheme,
      primaryColor: colors.brand,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      cardColor: colors.surfaceElevated,
      dividerColor: colors.stroke,
      disabledColor: colors.textMuted.withValues(alpha: 0.55),
      shadowColor: colors.shadow,
      splashColor: colors.brand.withValues(alpha: 0.08),
      highlightColor: colors.brand.withValues(alpha: 0.04),
      extensions: [colors],
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: colors.textSecondary, size: 22.sp),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: AppComponentThemes.appBar(colors),
      inputDecorationTheme: AppComponentThemes.input(colors),
      elevatedButtonTheme: AppComponentThemes.elevatedButton(colors),
      filledButtonTheme: AppComponentThemes.filledButton(colors),
      outlinedButtonTheme: AppComponentThemes.outlinedButton(colors),
      textButtonTheme: AppComponentThemes.textButton(colors),
      cardTheme: AppComponentThemes.card(colors),
      bottomSheetTheme: AppComponentThemes.bottomSheet(colors),
      dialogTheme: AppComponentThemes.dialog(colors),
      snackBarTheme: AppComponentThemes.snackBar(colors),
      switchTheme: AppComponentThemes.switchTheme(colors),
      chipTheme: AppComponentThemes.chip(colors),
      navigationBarTheme: AppComponentThemes.navigationBar(colors),
      dividerTheme: DividerThemeData(color: colors.stroke, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.brand,
        linearTrackColor: colors.surfaceMuted,
        circularTrackColor: colors.surfaceMuted,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.brand
              : Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: colors.strokeStrong, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.brand
              : colors.textMuted;
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.textPrimary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        textStyle: TextStyle(color: colors.canvas, fontSize: 11.sp),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: colors.stroke),
        ),
      ),
    );
  }
}
