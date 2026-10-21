import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/orders/presentation/widgets/order_progress_tracker.dart';
import 'package:scannerapp/feature/orders/presentation/widgets/order_status_pill.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final user = GlobalService.instance.currentUser;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(title: const Text('Order details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORDER ${order.id}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: .15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppFormat.money(order.total),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  'Placed ${AppFormat.shortDate(order.placedAt)} · ${order.itemCount} units',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          _DetailsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Delivery status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    OrderStatusPill(status: order.status),
                  ],
                ),
                const SizedBox(height: 25),
                OrderProgressTracker(status: order.status),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Text(
            'Items in this order',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 11),
          _DetailsCard(
            child: Column(
              children: [
                for (var i = 0; i < order.items.length; i++) ...[
                  if (i > 0) ...[Divider(height: 25, color: colors.stroke)],
                  _OrderLine(item: order.items[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 17),
          _DetailsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _AmountRow(
                  label: 'Products',
                  value: AppFormat.money(order.subtotal),
                ),
                const SizedBox(height: 10),
                _AmountRow(
                  label: 'Delivery',
                  value: order.deliveryFee == 0
                      ? 'Free'
                      : AppFormat.money(order.deliveryFee),
                ),
                if (order.discount > 0) ...[
                  const SizedBox(height: 10),
                  _AmountRow(
                    label: 'Coupon (${order.couponCode})',
                    value: '-${AppFormat.money(order.discount)}',
                  ),
                ],
                Divider(height: 28, color: colors.stroke),
                _AmountRow(
                  label: 'Total',
                  value: AppFormat.money(order.total),
                  strong: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          _DetailsCard(
            child: Row(
              children: [
                Icon(AppIcons.location, color: colors.brand),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery address',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?.pharmacyName ?? 'Your pharmacy',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        user?.address ?? 'Dhaka, Bangladesh',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.stroke),
      ),
      child: child,
    );
  }
}

class _OrderLine extends StatelessWidget {
  const _OrderLine({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 60,
          child: ProductVisual(
            name: product.name,
            category: DemoCatalog.categoryById(product.categoryId).name,
            compact: true,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 3),
              Text(
                '${item.quantity} × ${AppFormat.money(product.price)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text(
          AppFormat.money(item.lineTotal),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: strong
              ? Theme.of(context).textTheme.titleSmall
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style:
              (strong
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.labelLarge)
                  ?.copyWith(color: strong ? colors.brand : colors.textPrimary),
        ),
      ],
    );
  }
}
