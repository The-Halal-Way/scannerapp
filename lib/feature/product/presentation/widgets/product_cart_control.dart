import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

/// Shows an add action until the item is in the cart, then edits its quantity.
class ProductCartControl extends StatelessWidget {
  const ProductCartControl({
    super.key,
    required this.quantity,
    required this.stock,
    required this.onAdd,
    required this.onDecrease,
    required this.onIncrease,
    this.compact = false,
  });

  final int quantity;
  final int stock;
  final VoidCallback onAdd;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = compact ? 28.0 : 34.0;
    if (quantity == 0) {
      return IconButton.filled(
        tooltip: stock > 0 ? 'Add to cart' : 'Out of stock',
        onPressed: stock > 0 ? onAdd : null,
        icon: Icon(AppIcons.add, size: compact ? 17 : 20),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: size, height: size),
        style: IconButton.styleFrom(
          minimumSize: Size.zero,
          fixedSize: Size(size, size),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: colors.brand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compact ? 9 : 11),
          ),
        ),
      );
    }

    return Container(
      height: size,
      decoration: BoxDecoration(
        color: colors.brand.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(compact ? 9 : 11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepButton(
            tooltip: 'Decrease quantity',
            icon: AppIcons.remove,
            onPressed: onDecrease,
            size: size,
            colors: colors,
          ),
          SizedBox(
            width: compact ? 17 : 22,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _stepButton(
            tooltip: 'Increase quantity',
            icon: AppIcons.add,
            onPressed: quantity < stock ? onIncrease : null,
            size: size,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _stepButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
    required double size,
    required AppThemeColors colors,
  }) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: compact ? 13 : 16),
    padding: EdgeInsets.zero,
    constraints: BoxConstraints.tightFor(
      width: compact ? 22 : 28,
      height: size,
    ),
    color: colors.brand,
    disabledColor: colors.textMuted,
    style: IconButton.styleFrom(
      minimumSize: Size.zero,
      fixedSize: Size(compact ? 22 : 28, size),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
