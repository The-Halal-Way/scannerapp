import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.name,
    required this.favoriteCount,
    this.onSearchTap,
    this.onFavoritesTap,
    this.onProfileTap,
  });

  final String name;
  final int favoriteCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final firstName = name.trim().split(' ').first;

    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              _BrandMark(color: colors.brand),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEDCLUB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.brand,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .15,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Hello, ${name.trim()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _HeaderAction(
                icon: AppIcons.favorite,
                label: 'Open favorites',
                count: favoriteCount,
                onTap: onFavoritesTap,
              ),
              SizedBox(width: 7.w),
              InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  height: 42.r,
                  width: 42.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.violet, colors.brand],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: colors.brand.withValues(alpha: 0.22),
                        blurRadius: 15,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Text(
                    firstName.isEmpty ? 'M' : firstName[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Material(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(18.r),
            child: InkWell(
              onTap: onSearchTap,
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
                    SizedBox(width: 12.w),
                    Icon(AppIcons.filter, color: colors.brand, size: 21.sp),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(AppIcons.medical, color: color, size: 23.sp),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: count > 0 ? '$label, $count items' : label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.stroke),
                ),
                child: Icon(icon, color: colors.textPrimary, size: 21.sp),
              ),
              if (count > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    height: 19.r,
                    constraints: BoxConstraints(minWidth: 19.r),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.coral,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: colors.canvas, width: 2),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                      ),
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
