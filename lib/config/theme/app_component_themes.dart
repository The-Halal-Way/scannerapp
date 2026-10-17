import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

abstract final class AppComponentThemes {
  static AppBarThemeData appBar(AppThemeColors colors) {
    return AppBarThemeData(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: colors.canvas,
      foregroundColor: colors.textPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: colors.textPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: colors.textSecondary, size: 22.sp),
      actionsIconTheme: IconThemeData(color: colors.textSecondary, size: 22.sp),
    );
  }

  static InputDecorationTheme input(AppThemeColors colors) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colors.surfaceMuted,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      hintStyle: TextStyle(color: colors.textMuted, fontSize: 14.sp),
      labelStyle: TextStyle(color: colors.textSecondary, fontSize: 14.sp),
      floatingLabelStyle: TextStyle(
        color: colors.brand,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: colors.textMuted,
      suffixIconColor: colors.textMuted,
      iconColor: colors.textMuted,
      enabledBorder: border(colors.stroke),
      focusedBorder: border(colors.brand, 1.6),
      disabledBorder: border(colors.stroke.withValues(alpha: 0.55)),
      errorBorder: border(colors.danger),
      focusedErrorBorder: border(colors.danger, 1.6),
      errorStyle: TextStyle(
        color: colors.danger,
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButton(AppThemeColors colors) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        minimumSize: WidgetStatePropertyAll(Size(80.w, 52.h)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.strokeStrong;
          }
          return colors.brand;
        }),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        overlayColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.12),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }

  static FilledButtonThemeData filledButton(AppThemeColors colors) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(80.w, 52.h)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.disabled)
              ? colors.strokeStrong
              : colors.brand;
        }),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButton(AppThemeColors colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(80.w, 50.h)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
        ),
        backgroundColor: WidgetStatePropertyAll(colors.surfaceElevated),
        foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
        side: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.focused)
              ? colors.brand
              : colors.strokeStrong;
          return BorderSide(color: color);
        }),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }

  static TextButtonThemeData textButton(AppThemeColors colors) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(colors.brand),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }

  static CardThemeData card(AppThemeColors colors) {
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shadowColor: colors.shadow.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: colors.stroke),
      ),
    );
  }

  static BottomSheetThemeData bottomSheet(AppThemeColors colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: Colors.black.withValues(alpha: 0.62),
      showDragHandle: true,
      dragHandleColor: colors.strokeStrong,
      dragHandleSize: Size(38.w, 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
    );
  }

  static DialogThemeData dialog(AppThemeColors colors) {
    return DialogThemeData(
      elevation: 0,
      backgroundColor: colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shadowColor: colors.shadow.withValues(alpha: 0.28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.r),
        side: BorderSide(color: colors.stroke),
      ),
    );
  }

  static SnackBarThemeData snackBar(AppThemeColors colors) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: colors.textPrimary,
      contentTextStyle: TextStyle(
        color: colors.canvas,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
      actionTextColor: colors.cyan,
      insetPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    );
  }

  static SwitchThemeData switchTheme(AppThemeColors colors) {
    return SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.stroke.withValues(alpha: 0.6);
        }
        return states.contains(WidgetState.selected)
            ? colors.brand
            : colors.strokeStrong;
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.textMuted;
        return states.contains(WidgetState.selected)
            ? Colors.white
            : colors.surface;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static ChipThemeData chip(AppThemeColors colors) {
    return ChipThemeData(
      backgroundColor: colors.surfaceMuted,
      selectedColor: colors.brand.withValues(alpha: 0.14),
      disabledColor: colors.surfaceMuted.withValues(alpha: 0.5),
      side: BorderSide(color: colors.stroke),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999.r)),
      labelStyle: TextStyle(
        color: colors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: TextStyle(
        color: colors.brand,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      showCheckmark: false,
    );
  }

  static NavigationBarThemeData navigationBar(AppThemeColors colors) {
    return NavigationBarThemeData(
      height: 70.h,
      elevation: 0,
      backgroundColor: colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      indicatorColor: colors.brand.withValues(alpha: 0.14),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? colors.brand
              : colors.textMuted,
          size: 23.sp,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          color: states.contains(WidgetState.selected)
              ? colors.brand
              : colors.textMuted,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        );
      }),
    );
  }
}
