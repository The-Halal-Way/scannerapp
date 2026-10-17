import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardCategoryCard extends StatelessWidget {
  const DashboardCategoryCard({
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
      colors.violet,
    ][index % 5];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19.r),
        child: SizedBox(
          width: 94.w,
          child: Column(
            children: [
              Container(
                width: 83.r,
                height: 72.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withValues(alpha: .18),
                      accent.withValues(alpha: .06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: accent.withValues(alpha: .12)),
                ),
                child: Icon(_iconFor(name), size: 33.sp, color: accent),
              ),
              SizedBox(height: 8.h),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.textPrimary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String category) {
    final text = category.toLowerCase();
    if (text.contains('vitamin') || text.contains('supplement')) {
      return Icons.spa_rounded;
    }
    if (text.contains('skin') || text.contains('care')) {
      return Icons.water_drop_rounded;
    }
    if (text.contains('device') || text.contains('equipment')) {
      return Icons.monitor_heart_rounded;
    }
    if (text.contains('first') || text.contains('surgical')) {
      return Icons.medical_services_rounded;
    }
    if (text.contains('pain')) return Icons.healing_rounded;
    return Icons.medication_rounded;
  }
}
