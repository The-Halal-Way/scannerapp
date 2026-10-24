import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_promo_art.dart';

class DashboardPromoSlide extends StatelessWidget {
  const DashboardPromoSlide({super.key, required this.index, this.onTap});

  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = _PromoContent.forIndex(index, colors);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: content.gradient,
        ),
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -43.w,
            top: -62.h,
            child: _Orb(
              size: 154.r,
              color: Colors.white.withValues(alpha: .06),
            ),
          ),
          Positioned(
            right: 27.w,
            bottom: -62.h,
            child: _Orb(
              size: 115.r,
              color: content.accent.withValues(alpha: .15),
            ),
          ),
          Positioned(
            left: -19.w,
            bottom: -31.h,
            child: _Orb(size: 66.r, color: colors.coral.withValues(alpha: .12)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 10.h, 0, 10.h),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .16),
                          ),
                        ),
                        child: Text(
                          content.eyebrow,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: content.accent,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .1,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              height: 1.06,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.4,
                            ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(99),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              content.action,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                              height: 19.r,
                              width: 19.r,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7.r),
                              ),
                              child: Icon(
                                AppIcons.outward,
                                size: 13.sp,
                                color: content.gradient[1],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: DashboardPromoArt(
                    primaryAccent: content.primaryAccent,
                    secondaryAccent: content.secondaryAccent,
                    primaryLabel: content.primaryLabel,
                    secondaryLabel: content.secondaryLabel,
                    primaryIcon: content.primaryIcon,
                    secondaryIcon: content.secondaryIcon,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _PromoContent {
  const _PromoContent({
    required this.eyebrow,
    required this.title,
    required this.action,
    required this.gradient,
    required this.accent,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryIcon,
    required this.secondaryIcon,
  });

  final String eyebrow;
  final String title;
  final String action;
  final List<Color> gradient;
  final Color accent;
  final Color primaryAccent;
  final Color secondaryAccent;
  final String primaryLabel;
  final String secondaryLabel;
  final IconData primaryIcon;
  final IconData secondaryIcon;

  static _PromoContent forIndex(int index, AppThemeColors colors) =>
      switch (index) {
        1 => _PromoContent(
          eyebrow: 'EVERYDAY ESSENTIALS',
          title: 'Care that keeps\nyou ready.',
          action: 'Browse products',
          gradient: [
            colors.heroStart,
            const Color(0xFF086C87),
            const Color(0xFF0AAFC3),
          ],
          accent: const Color(0xFF8DF2FF),
          primaryAccent: colors.cyan,
          secondaryAccent: colors.violet,
          primaryLabel: 'ESSENTIALS',
          secondaryLabel: 'DAILY CARE',
          primaryIcon: AppIcons.medical,
          secondaryIcon: AppIcons.heart,
        ),
        2 => _PromoContent(
          eyebrow: 'RESTOCK WITH EASE',
          title: 'Your shelves,\nwell supplied.',
          action: 'Explore catalog',
          gradient: [
            colors.heroStart,
            const Color(0xFF753474),
            const Color(0xFFD85089),
          ],
          accent: const Color(0xFFFFC4DE),
          primaryAccent: colors.coral,
          secondaryAccent: colors.warning,
          primaryLabel: 'PHARMACY',
          secondaryLabel: 'SUPPLY',
          primaryIcon: AppIcons.package,
          secondaryIcon: AppIcons.shield,
        ),
        _ => _PromoContent(
          eyebrow: 'FOR YOUR PHARMACY',
          title: 'Better stock.\nBetter care.',
          action: 'Shop offers',
          gradient: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
          accent: colors.cyan,
          primaryAccent: colors.coral,
          secondaryAccent: colors.cyan,
          primaryLabel: 'ITTADI',
          secondaryLabel: 'ESSENTIALS',
          primaryIcon: AppIcons.shield,
          secondaryIcon: AppIcons.liquid,
        ),
      };
}
