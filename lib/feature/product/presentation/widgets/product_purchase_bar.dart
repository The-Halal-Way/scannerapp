import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    super.key,
    required this.quantity,
    required this.remaining,
    required this.stock,
    required this.unitPrice,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAdd,
    required this.onViewCart,
  });

  final int quantity;
  final int remaining;
  final int stock;
  final int unitPrice;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAdd;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final available = remaining > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.stroke)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .09),
            blurRadius: 25,
            offset: const Offset(0, -9),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 116,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Decrease quantity',
                    onPressed: available && quantity > 1 ? onDecrease : null,
                    icon: const Icon(Icons.remove_rounded, size: 17),
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Text(
                      available ? '$quantity' : '—',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Increase quantity',
                    onPressed: available && quantity < remaining
                        ? onIncrease
                        : null,
                    icon: const Icon(Icons.add_rounded, size: 17),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: stock == 0
                      ? null
                      : available
                      ? onAdd
                      : onViewCart,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stock == 0
                          ? 'Out of stock'
                          : available
                          ? 'Add to cart  •  ৳${quantity * unitPrice}'
                          : 'View cart',
                      style: const TextStyle(fontWeight: FontWeight.w800),
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
