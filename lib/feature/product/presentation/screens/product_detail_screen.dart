import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_detail_hero.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_detail_info.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_purchase_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final product = widget.product;
    final remaining = math.max(
      0,
      product.stock - shop.cartQuantityFor(product),
    );
    final quantity = remaining > 0 ? math.min(_quantity, remaining) : 0;

    return Scaffold(
      backgroundColor: context.appColors.canvas,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProductDetailHero(
              product: product,
              cartCount: shop.cartCount,
              onBack: () => Navigator.of(context).maybePop(),
              onCartTap: _openCart,
            ),
          ),
          SliverToBoxAdapter(child: ProductDetailInfo(product: product)),
        ],
      ),
      bottomNavigationBar: ProductPurchaseBar(
        quantity: quantity,
        remaining: remaining,
        stock: product.stock,
        unitPrice: product.price,
        onDecrease: () => setState(() => _quantity = math.max(1, quantity - 1)),
        onIncrease: () =>
            setState(() => _quantity = math.min(remaining, quantity + 1)),
        onAdd: () => _addToCart(quantity),
        onViewCart: _openCart,
      ),
    );
  }

  void _addToCart(int quantity) {
    if (quantity <= 0) return;
    context.read<ShopProvider>().addToCart(widget.product, quantity: quantity);
    setState(() => _quantity = 1);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$quantity ${quantity == 1 ? 'pack' : 'packs'} added to cart',
          ),
          action: SnackBarAction(label: 'VIEW CART', onPressed: _openCart),
        ),
      );
  }

  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }
}
