import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

/// Expands to edit a quantity, then returns to a compact quantity button.
class ProductCartControl extends StatefulWidget {
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
  State<ProductCartControl> createState() => _ProductCartControlState();
}

class _ProductCartControlState extends State<ProductCartControl> {
  static const _collapseDelay = Duration(seconds: 3);
  Timer? _collapseTimer;
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant ProductCartControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quantity == 0) {
      _collapseTimer?.cancel();
      _expanded = false;
    } else if (oldWidget.quantity == 0) {
      _expanded = true;
      _scheduleCollapse();
    } else if (widget.quantity != oldWidget.quantity && _expanded) {
      _scheduleCollapse();
    }
  }

  void _scheduleCollapse() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(_collapseDelay, () {
      if (mounted) setState(() => _expanded = false);
    });
  }

  void _expand() {
    setState(() => _expanded = true);
    _scheduleCollapse();
  }

  void _step(VoidCallback action) {
    _scheduleCollapse();
    action();
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: const Duration(milliseconds: 180),
    curve: Curves.easeOutCubic,
    alignment: Alignment.centerRight,
    child: _buildControl(context),
  );

  Widget _buildControl(BuildContext context) {
    final compact = widget.compact;
    final quantity = widget.quantity;
    final stock = widget.stock;
    final colors = context.appColors;
    final size = compact ? 28.0 : 34.0;
    if (quantity == 0) {
      return IconButton.filled(
        tooltip: stock > 0 ? 'Add to cart' : 'Out of stock',
        onPressed: stock > 0 ? widget.onAdd : null,
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

    if (!_expanded) {
      return Semantics(
        button: true,
        label: 'Quantity $quantity. Change quantity',
        onTap: _expand,
        excludeSemantics: true,
        child: Tooltip(
          message: 'Change quantity',
          child: TextButton(
            onPressed: _expand,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              fixedSize: Size(size, size),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: colors.textPrimary,
              foregroundColor: colors.surface,
              shape: const CircleBorder(),
              textStyle: TextStyle(
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Text('$quantity', maxLines: 1),
          ),
        ),
      );
    }

    return _buildStepper(colors, size);
  }

  Widget _buildStepper(AppThemeColors colors, double size) {
    final compact = widget.compact;
    final quantity = widget.quantity;
    final stock = widget.stock;
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
            onPressed: () => _step(widget.onDecrease),
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
            onPressed: quantity < stock ? () => _step(widget.onIncrease) : null,
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
    icon: Icon(icon, size: widget.compact ? 13 : 16),
    padding: EdgeInsets.zero,
    constraints: BoxConstraints.tightFor(
      width: widget.compact ? 22 : 28,
      height: size,
    ),
    color: colors.brand,
    disabledColor: colors.textMuted,
    style: IconButton.styleFrom(
      minimumSize: Size.zero,
      fixedSize: Size(widget.compact ? 22 : 28, size),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
