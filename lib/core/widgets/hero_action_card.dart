import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

/// Frosted-glass call-to-action card used inside gradient hero sections.
class HeroActionCard extends StatelessWidget {
  const HeroActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.105),
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.cyan.withValues(alpha: 0.8),
                          colors.brand,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(11.r),
                      boxShadow: [
                        BoxShadow(
                          color: colors.cyan.withValues(alpha: 0.18),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 18.sp, color: Colors.white),
                  ),
                  const Spacer(),
                  Icon(
                    AppIcons.outward,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 16.sp,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.62),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
