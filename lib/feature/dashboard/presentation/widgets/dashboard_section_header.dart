import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel = 'See all',
    this.onActionTap,
  });

  final String title;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null) ...[
                  Text(
                    subtitle!.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.brand,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.6,
                  ),
                ),
              ],
            ),
          ),
          if (onActionTap != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(99),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                child: Row(
                  children: [
                    Text(
                      actionLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.brand,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.sp,
                      color: colors.brand,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
