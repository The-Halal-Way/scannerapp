import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/home/presentation/widgets/home_nav_item.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({
    super.key,
    required this.currentPage,
    required this.onPageChange,
  });

  final int currentPage;
  final ValueChanged<int> onPageChange;

  static const _items = <HomeNavDestination>[
    HomeNavDestination(
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard_rounded,
    ),
    HomeNavDestination(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    HomeNavDestination(
      label: 'Search',
      icon: Icons.search_rounded,
      selectedIcon: Icons.manage_search_rounded,
    ),
    HomeNavDestination(
      label: 'Inbox',
      icon: Icons.mail_outline_rounded,
      selectedIcon: Icons.mail_rounded,
    ),
    HomeNavDestination(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: colors.surfaceElevated.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: colors.stroke),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.34
                    : 0.13,
              ),
              blurRadius: 30.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            _items.length,
            (index) => HomeNavItem(
              destination: _items[index],
              isSelected: currentPage == index,
              onTap: () => onPageChange(index),
            ),
          ),
        ),
      ),
    );
  }
}
