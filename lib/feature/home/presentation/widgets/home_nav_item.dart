import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class HomeNavDestination {
  const HomeNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class HomeNavItem extends StatelessWidget {
  const HomeNavItem({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final HomeNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Expanded(
      child: Semantics(
        selected: isSelected,
        button: true,
        label: destination.label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: isSelected ? 35.r : 29.r,
                  height: 29.r,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [colors.brand, colors.violet],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.brand.withValues(alpha: 0.28),
                              blurRadius: 12.r,
                              offset: Offset(0, 4.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isSelected ? destination.selectedIcon : destination.icon,
                    size: isSelected ? 18.sp : 20.sp,
                    color: isSelected ? Colors.white : colors.textMuted,
                  ),
                ),
                SizedBox(height: 3.h),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: isSelected ? colors.brand : colors.textMuted,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
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
