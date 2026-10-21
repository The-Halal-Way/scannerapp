import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/coupons/data/demo_coupons.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_picker_sheet.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_ticket_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_section_header.dart';

class DashboardCouponSection extends StatelessWidget {
  const DashboardCouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accents = [colors.brand, colors.cyan, colors.coral];
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          DashboardSectionHeader(
            title: 'Coupons for you',
            icon: AppIcons.offer,
            accent: colors.brand,
            onActionTap: () => CouponPickerSheet.show(context),
          ),
          SizedBox(height: 3.5.h),
          SizedBox(
            height: 128.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              itemCount: DemoCoupons.coupons.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final coupon = DemoCoupons.coupons[index];
                return SizedBox(
                  width: 270.w,
                  child: CouponTicketCard(
                    coupon: coupon,
                    accent: accents[index % accents.length],
                    actionLabel: 'Copy code',
                    actionIcon: AppIcons.copy,
                    onAction: () async {
                      await Clipboard.setData(ClipboardData(text: coupon.code));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              '${coupon.code} copied. Apply it in your cart.',
                            ),
                          ),
                        );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
