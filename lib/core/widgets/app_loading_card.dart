import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/widgets/app_surface.dart';

class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppSurface(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
      child: Row(
        children: [
          SizedBox(
            width: 22.r,
            height: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: colors.brand,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
