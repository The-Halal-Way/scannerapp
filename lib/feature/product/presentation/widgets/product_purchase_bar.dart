import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_cart_control.dart';

class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    super.key,
    required this.cartQuantity,
    required this.stock,
    required this.unitPrice,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAdd,
    required this.onViewCart,
  });

  final int cartQuantity;
  final int stock;
  final int unitPrice;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAdd;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.stroke)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Visibility(
              visible: cartQuantity > 0,
              maintainState: true,
              child: ProductCartControl(
                quantity: cartQuantity,
                stock: stock,
                onAdd: onAdd,
                onDecrease: onDecrease,
                onIncrease: onIncrease,
              ),
            ),
            if (cartQuantity > 0) const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: stock == 0
                      ? null
                      : cartQuantity > 0
                      ? onViewCart
                      : onAdd,
                  child: Text(
                    stock == 0
                        ? 'Out of stock'
                        : cartQuantity > 0
                        ? 'View cart · ৳${cartQuantity * unitPrice}'
                        : 'Add to cart · ৳$unitPrice',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
