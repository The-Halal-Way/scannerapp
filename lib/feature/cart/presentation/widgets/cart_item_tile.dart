import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/util/app_format.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final store = context.read<ShopProvider>();
    final category = DemoCatalog.categoryById(product.categoryId).name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            height: 100,
            child: ProductVisual(
              name: product.name,
              category: category,
              compact: true,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  product.unit,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 9),
                Text(
                  AppFormat.money(item.lineTotal),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.brand,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: item.quantity == 1
                          ? Icons.delete_outline_rounded
                          : Icons.remove_rounded,
                      label: 'Decrease ${product.name} quantity',
                      onTap: () =>
                          store.setCartQuantity(product, item.quantity - 1),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      label: 'Increase ${product.name} quantity',
                      onTap: item.quantity >= product.stock
                          ? null
                          : () => store.setCartQuantity(
                              product,
                              item.quantity + 1,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 17,
            color: onTap == null ? colors.textMuted : colors.brand,
          ),
        ),
      ),
    );
  }
}
