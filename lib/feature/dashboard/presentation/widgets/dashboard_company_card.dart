import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardCompanyCard extends StatelessWidget {
  const DashboardCompanyCard({
    super.key,
    required this.name,
    required this.index,
    this.onTap,
  });

  final String name;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = [
      colors.brand,
      colors.cyan,
      colors.coral,
      colors.success,
    ][index % 4];
    final initials = name
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();

    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: 153.w,
          padding: EdgeInsets.all(11.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: colors.stroke),
          ),
          child: Row(
            children: [
              Container(
                width: 43.r,
                height: 43.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.sp,
                    letterSpacing: -.5,
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
