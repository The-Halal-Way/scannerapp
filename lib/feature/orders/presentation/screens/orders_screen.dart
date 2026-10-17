import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/orders/presentation/screens/order_details_screen.dart';
import 'package:scannerapp/feature/orders/presentation/widgets/order_card.dart';

enum _OrderFilter { all, active, delivered }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _OrderFilter _filter = _OrderFilter.all;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shop = context.watch<ShopProvider>();
    final orders = shop.orders
        .where(
          (order) => switch (_filter) {
            _OrderFilter.all => true,
            _OrderFilter.active => order.status != OrderStatus.delivered,
            _OrderFilter.delivered => order.status == OrderStatus.delivered,
          },
        )
        .toList();
    final activeCount = shop.orders
        .where((order) => order.status != OrderStatus.delivered)
        .length;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your orders',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Every restock, right on track.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Open cart',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const CartScreen()),
                  ),
                  icon: Badge(
                    isLabelVisible: shop.cartCount > 0,
                    label: Text('${shop.cartCount}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _OrdersHero(activeCount: activeCount),
            const SizedBox(height: 25),
            Text(
              'Order history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == _OrderFilter.all,
                  onTap: () => setState(() => _filter = _OrderFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Active',
                  selected: _filter == _OrderFilter.active,
                  onTap: () => setState(() => _filter = _OrderFilter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Delivered',
                  selected: _filter == _OrderFilter.delivered,
                  onTap: () => setState(() => _filter = _OrderFilter.delivered),
                ),
              ],
            ),
            const SizedBox(height: 17),
            if (orders.isEmpty)
              _EmptyOrders(filter: _filter)
            else
              ...orders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrderCard(
                    order: order,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrdersHero extends StatelessWidget {
  const _OrdersHero({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      constraints: const BoxConstraints(minHeight: 168),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -22,
            child: Icon(
              Icons.local_shipping_rounded,
              size: 154,
              color: Colors.white.withValues(alpha: .11),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SUPPLY PIPELINE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$activeCount active ${activeCount == 1 ? 'order' : 'orders'}',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 3),
              Text(
                'Keep your shelves stocked with ease',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.brand : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? colors.brand : colors.stroke),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.filter});

  final _OrderFilter filter;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 40, color: colors.brand),
          const SizedBox(height: 12),
          Text(
            filter == _OrderFilter.active
                ? 'No active orders'
                : 'No orders here yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Your pharmacy orders will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
