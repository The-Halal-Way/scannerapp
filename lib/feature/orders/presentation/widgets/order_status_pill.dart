import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';

class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({super.key, required this.status});

  final OrderStatus status;

  static String label(OrderStatus status) => switch (status) {
    OrderStatus.placed => 'Placed',
    OrderStatus.onTheWay => 'On the way',
    OrderStatus.delivered => 'Delivered',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = switch (status) {
      OrderStatus.placed => colors.brand,
      OrderStatus.onTheWay => colors.cyan,
      OrderStatus.delivered => colors.success,
    };
    final icon = switch (status) {
      OrderStatus.placed => Icons.check_circle_outline_rounded,
      OrderStatus.onTheWay => Icons.local_shipping_outlined,
      OrderStatus.delivered => Icons.done_all_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label(status),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
