import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    this.actionLabel = 'View all',
    this.onActionTap,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: accent, size: 20.sp),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -.35,
              ),
            ),
          ),
          if (onActionTap != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(99),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.brand,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      AppIcons.forwardSmall,
                      size: 13.sp,
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
