import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';

class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({super.key, required this.shop});

  final ShopProvider shop;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal',
            value: AppFormat.money(shop.cartSubtotal),
          ),
          const SizedBox(height: 11),
          _SummaryRow(
            label: 'Delivery',
            value: shop.deliveryFee == 0
                ? 'FREE'
                : AppFormat.money(shop.deliveryFee),
            valueColor: shop.deliveryFee == 0 ? colors.success : null,
          ),
          if (shop.couponDiscount > 0) ...[
            const SizedBox(height: 11),
            _SummaryRow(
              label: 'Coupon (${shop.appliedCoupon!.code})',
              value: '-${AppFormat.money(shop.couponDiscount)}',
              valueColor: colors.success,
            ),
          ],
          const SizedBox(height: 15),
          Divider(color: colors.stroke, height: 1),
          const SizedBox(height: 15),
          _SummaryRow(
            label: 'Total',
            value: AppFormat.money(shop.cartTotal),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: emphasize
              ? Theme.of(context).textTheme.titleSmall
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style:
              (emphasize
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.labelLarge)
                  ?.copyWith(
                    color:
                        valueColor ??
                        (emphasize ? colors.brand : colors.textPrimary),
                  ),
        ),
      ],
    );
  }
}
