import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key, this.onTap, this.onVoiceTap});

  final VoidCallback? onTap;
  final VoidCallback? onVoiceTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 6.h, 13.w, 0),
      child: Material(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            height: 49.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              border: Border.all(color: colors.stroke),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Icon(AppIcons.search, color: colors.brand, size: 23.sp),
                SizedBox(width: 11.w),
                Expanded(
                  child: Text(
                    'Search medicines, brands, essentials',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Container(width: 1, height: 22.h, color: colors.stroke),
                SizedBox(width: 5.w),
                IconButton(
                  tooltip: 'Search by voice',
                  onPressed: onVoiceTap,
                  icon: Icon(AppIcons.microphone, color: colors.brand),
                  iconSize: 21.sp,
                  visualDensity: VisualDensity.compact,
                  constraints: BoxConstraints.tightFor(
                    width: 35.w,
                    height: 42.h,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
