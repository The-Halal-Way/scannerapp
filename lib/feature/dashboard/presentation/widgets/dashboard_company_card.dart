import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
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
    final muted = dark ? Colors.white70 : colors.textSecondary;

    return Semantics(
      button: true,
      label: 'Browse ${company.name}',
      child: Material(
        color: dark ? colors.heroStart : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(17.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17.r),
          child: Container(
            width: 158.w,
            padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.r),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: .16)
                    : colors.stroke,
              ),
              gradient: dark
                  ? LinearGradient(
                      colors: [colors.heroStart, colors.heroMiddle],
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRUSTED MAKER',
                  style: TextStyle(
                    color: dark ? colors.cyan : colors.brand,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: Image.asset(
                    company.logoAsset,
                    width: 132.w,
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
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.shortName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: foreground,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            company.tagline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: muted, fontSize: 8.sp),
                          ),
                        ],
                      ),
                    ),
                    Icon(AppIcons.outward, color: muted, size: 13.sp),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
