import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/home/presentation/screens/home.dart';
import 'package:scannerapp/feature/orders/presentation/screens/order_details_screen.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 136,
                height: 136,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.brand, colors.violet],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.brand.withValues(alpha: .26),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 74,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'Order placed!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Your restock is on its way to the next step. Keep track of it in Orders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.stroke),
                ),
                child: Column(
                  children: [
                    Text(
                      order.id,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${order.itemCount} units · ${AppFormat.money(order.total)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OrderDetailsScreen(order: order),
                    ),
                  ),
                  child: const Text('View order details'),
                ),
              ),
              const SizedBox(height: 7),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const Home(initialPage: 1),
                  ),
                  (_) => false,
                ),
                child: const Text('Go to orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
