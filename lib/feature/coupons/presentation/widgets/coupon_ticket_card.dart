import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/coupons/data/models/coupon.dart';

class CouponTicketCard extends StatelessWidget {
  const CouponTicketCard({
    super.key,
    required this.coupon,
    required this.accent,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  final Coupon coupon;
  final Color accent;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 128.h,
      padding: EdgeInsets.all(11.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.lerp(colors.surface, accent, .10)!,
            colors.surfaceElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: accent.withValues(alpha: .25)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 69.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.offer, color: accent, size: 20.sp),
                SizedBox(height: 8.h),
                Text(
                  coupon.savingsLabel,
                  maxLines: 1,
                  style: TextStyle(
                    color: accent,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'OFF',
                  style: TextStyle(
                    color: accent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          CustomPaint(
            size: Size(1, double.infinity),
            painter: _TicketDivider(accent.withValues(alpha: .30)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.code,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  coupon.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'On orders ${AppFormat.money(coupon.minimumSpend)}+${coupon.maxDiscount == null ? '' : '\nSave up to ${AppFormat.money(coupon.maxDiscount!)}'}',
                  maxLines: 2,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 9.sp,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 12.sp),
                  label: Text(actionLabel, maxLines: 1),
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                    disabledForegroundColor: colors.textMuted,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 24.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
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

class _TicketDivider extends CustomPainter {
  const _TicketDivider(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 7) {
      canvas.drawLine(
        Offset(0, y),
        Offset(0, (y + 3).clamp(0, size.height)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TicketDivider oldDelegate) =>
      color != oldDelegate.color;
}
