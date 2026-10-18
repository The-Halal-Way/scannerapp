import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPromoArt extends StatelessWidget {
  const DashboardPromoArt({
    super.key,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryIcon,
    required this.secondaryIcon,
  });

  final Color primaryAccent;
  final Color secondaryAccent;
  final String primaryLabel;
  final String secondaryLabel;
  final IconData primaryIcon;
  final IconData secondaryIcon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 17.h,
              right: -8.w,
              child: Transform.rotate(
                angle: .22,
                child: _Package(
                  width: width * .66,
                  height: 68.h,
                  accent: secondaryAccent,
                  label: secondaryLabel,
                  icon: secondaryIcon,
                ),
              ),
            ),
            Positioned(
              top: 5.h,
              left: -3.w,
              child: Transform.rotate(
                angle: -.14,
                child: _Package(
                  width: width * .65,
                  height: 72.h,
                  accent: primaryAccent,
                  label: primaryLabel,
                  icon: primaryIcon,
                ),
              ),
            ),
            Positioned(
              right: -5.w,
              bottom: 4.h,
              child: Transform.rotate(
                angle: -.65,
                child: Container(
                  width: 38.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: primaryAccent,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.white, width: 1.5),
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
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 7.h, color: accent),
          Padding(
            padding: EdgeInsets.all(6.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: accent, size: 20.sp),
                SizedBox(height: 5.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF272343),
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .1,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  width: width * .42,
                  height: 2.h,
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
