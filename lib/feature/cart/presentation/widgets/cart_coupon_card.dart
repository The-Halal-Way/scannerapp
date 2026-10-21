import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_picker_sheet.dart';

class CartCouponCard extends StatelessWidget {
  const CartCouponCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final coupon = shop.appliedCoupon;
    final colors = context.appColors;
    final active = shop.couponDiscount > 0;
    final message = coupon == null
        ? 'Choose a coupon for extra savings'
        : active
        ? 'You save ${AppFormat.money(shop.couponDiscount)} on this order'
        : 'Add ${AppFormat.money(coupon.minimumSpend - shop.cartSubtotal)} more to use this code';

    return Material(
      color: colors.brand.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => CouponPickerSheet.show(context),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              Icon(AppIcons.offer, color: colors.brand, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon == null
                          ? 'Apply a coupon'
                          : '${coupon.code}${active ? ' applied' : ''}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: active ? colors.success : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (coupon == null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    AppIcons.forwardSmall,
                    color: colors.brand,
                    size: 16,
                  ),
                )
              else
                IconButton(
                  tooltip: 'Remove coupon',
                  onPressed: shop.removeCoupon,
                  icon: const Icon(AppIcons.close, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
