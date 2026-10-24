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
        borderRadius: BorderRadius.circular(17.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17.r),
          child: Container(
            width: 126.w,
            padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32.h,
                  width: company.logoMarkOnly ? 32.w : double.infinity,
                  child: ClipRect(
                    child: Image.asset(
                      company.logoAsset,
                      fit: company.logoMarkOnly ? BoxFit.cover : BoxFit.contain,
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
                SizedBox(height: 4.h),
                Text(
                  company.shortName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: foreground,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
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
