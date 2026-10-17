import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/orders/presentation/widgets/order_status_pill.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final ShopOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(23),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: colors.stroke),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppFormat.shortDate(order.placedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  OrderStatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: 15),
              Divider(height: 1, color: colors.stroke),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 106,
                    height: 50,
                    child: Stack(
                      children: [
                        for (var i = 0; i < order.items.length && i < 3; i++)
                          Positioned(
                            left: i * 29,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: colors.surface,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ProductVisual(
                                  name: order.items[i].product.name,
                                  category: DemoCatalog.categoryById(
                                    order.items[i].product.categoryId,
                                  ).name,
                                  compact: true,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${order.itemCount} units · ${order.items.length} products',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppFormat.money(order.total),
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: colors.brand),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'View details →',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
