import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class DashboardPromoBanner extends StatelessWidget {
  const DashboardPromoBanner({super.key, this.onExploreTap});

  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 218.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(27.r),
        boxShadow: [
          BoxShadow(
            color: colors.brand.withValues(alpha: .24),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -62.w,
            top: -89.h,
            child: _Orb(
              size: 220.r,
              color: Colors.white.withValues(alpha: .06),
            ),
          ),
          Positioned(
            right: 38.w,
            bottom: -88.h,
            child: _Orb(size: 165.r, color: colors.cyan.withValues(alpha: .15)),
          ),
          Positioned(
            left: -27.w,
            bottom: -44.h,
            child: _Orb(size: 94.r, color: colors.coral.withValues(alpha: .12)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(23.w, 24.h, 0, 23.h),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .16),
                          ),
                        ),
                        child: Text(
                          'FOR YOUR PHARMACY',
                          style: TextStyle(
                            color: colors.cyan,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Better stock.\nBetter care.',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 21.sp,
                              height: 1.06,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.7,
                            ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onExploreTap,
                        borderRadius: BorderRadius.circular(99),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Shop offers',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Container(
                              height: 23.r,
                              width: 23.r,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9.r),
                              ),
                              child: Icon(
                                Icons.arrow_outward_rounded,
                                size: 15.sp,
                                color: colors.heroMiddle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 4, child: _MedicineArt(colors: colors)),
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
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _MedicineArt extends StatelessWidget {
  const _MedicineArt({required this.colors});

  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 36.h,
              right: -12.w,
              child: Transform.rotate(
                angle: .22,
                child: _Package(
                  width: width * .66,
                  height: 117.h,
                  accent: colors.cyan,
                  label: 'ESSENTIALS',
                  icon: Icons.medication_liquid_rounded,
                ),
              ),
            ),
            Positioned(
              top: 9.h,
              left: -4.w,
              child: Transform.rotate(
                angle: -.14,
                child: _Package(
                  width: width * .65,
                  height: 121.h,
                  accent: colors.coral,
                  label: 'MEDCLUB',
                  icon: Icons.health_and_safety_rounded,
                ),
              ),
            ),
            Positioned(
              right: -7.w,
              bottom: 9.h,
              child: Transform.rotate(
                angle: -.65,
                child: Container(
                  width: 54.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: colors.coral,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 12),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(99.r),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Package extends StatelessWidget {
  const _Package({
    required this.width,
    required this.height,
    required this.accent,
    required this.label,
    required this.icon,
  });

  final double width;
  final double height;
  final Color accent;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 10.h, color: accent),
          Padding(
            padding: EdgeInsets.all(9.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: accent, size: 28.sp),
                SizedBox(height: 18.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF272343),
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: width * .42,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(9),
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
