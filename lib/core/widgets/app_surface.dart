import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.color,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = borderRadius ?? BorderRadius.circular(20.r);
    final fill = color ?? colors.surfaceElevated;
    final decoration = BoxDecoration(
      color: fill,
      borderRadius: radius,
      border: Border.all(color: colors.stroke),
      boxShadow: [
        BoxShadow(
          color: colors.shadow.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark
                ? 0.18
                : 0.07,
          ),
          blurRadius: 24.r,
          offset: Offset(0, 8.h),
        ),
        if (accentColor != null)
          BoxShadow(
            color: accentColor!.withValues(alpha: 0.06),
            blurRadius: 20.r,
            spreadRadius: 1.r,
          ),
      ],
    );

    if (onTap == null) {
      return Container(padding: padding, decoration: decoration, child: child);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(padding: padding, decoration: decoration, child: child),
      ),
    );
  }
}
