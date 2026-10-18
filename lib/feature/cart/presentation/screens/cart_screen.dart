import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/cart/presentation/widgets/cart_item_tile.dart';
import 'package:scannerapp/feature/cart/presentation/widgets/cart_summary_card.dart';
import 'package:scannerapp/feature/orders/presentation/screens/order_placed_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shop = context.watch<ShopProvider>();
    final user = context.watch<GlobalService>().currentUser;
    final items = shop.cartItems;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: Text('Your cart', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  '${shop.cartCount} items',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: colors.brand),
                ),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? _EmptyCart(onContinue: () => Navigator.of(context).pop())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text(
                  'A healthier shelf starts here.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                if (shop.cartSubtotal < 1000) ...[
                  _DeliveryProgress(subtotal: shop.cartSubtotal),
                  const SizedBox(height: 20),
                ],
                ...items.map(
                  (item) =>
                      CartItemTile(key: ValueKey(item.product.id), item: item),
                ),
                const SizedBox(height: 10),
                CartSummaryCard(shop: shop),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.brand.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(AppIcons.location, color: colors.brand),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deliver to',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.pharmacyName ?? 'Your pharmacy',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              user?.deliveryArea ?? 'Dhaka',
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
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.stroke)),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          AppFormat.money(shop.cartTotal),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: colors.brand),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          final order = context
                              .read<ShopProvider>()
                              .placeOrder();
                          if (order == null) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => OrderPlacedScreen(order: order),
                            ),
                          );
                        },
                        icon: const Icon(AppIcons.forward),
                        iconAlignment: IconAlignment.end,
                        label: const Text('Place order'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DeliveryProgress extends StatelessWidget {
  const _DeliveryProgress({required this.subtotal});

  final int subtotal;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final remaining = 1000 - subtotal;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(AppIcons.delivery, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Add ${AppFormat.money(remaining)} for free delivery',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: subtotal / 1000,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: .2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 122,
              height: 122,
              decoration: BoxDecoration(
                color: colors.brand.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(AppIcons.bag, size: 58, color: colors.brand),
            ),
            const SizedBox(height: 28),
            Text(
              'Your cart is ready to fill',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore trusted pharmacy essentials and start your next restock.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: onContinue,
              icon: const Icon(AppIcons.back),
              label: const Text('Continue shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
