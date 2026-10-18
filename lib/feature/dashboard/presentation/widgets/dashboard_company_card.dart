import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/models/company.dart';

class DashboardCompanyCard extends StatelessWidget {
  const DashboardCompanyCard({super.key, required this.company, this.onTap});

  final Company company;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dark = company.logoOnDark;
    final foreground = dark ? Colors.white : colors.textPrimary;

    return Semantics(
      button: true,
      label: 'Browse ${company.name}',
      child: Material(
        color: dark ? colors.heroStart : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 96.w,
            padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: .12)
                    : colors.stroke,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      company.logoAsset,
                      width: 80.w,
                      height: 29.h,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, _, _) => Text(
                        company.shortName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: foreground),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  company.shortName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: dark ? Colors.white70 : colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
