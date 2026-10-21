import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_detail_hero.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_detail_info.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_purchase_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    return Scaffold(
      backgroundColor: context.appColors.canvas,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProductDetailHero(
              product: product,
              cartCount: shop.cartCount,
              isFavorite: shop.isFavorite(product),
              onBack: () => Navigator.of(context).maybePop(),
              onCartTap: () => _openCart(context),
              onFavoriteTap: () => shop.toggleFavorite(product),
            ),
          ),
          SliverToBoxAdapter(child: ProductDetailInfo(product: product)),
        ],
      ),
      bottomNavigationBar: ProductPurchaseBar(
        cartQuantity: shop.cartQuantityFor(product),
        stock: product.stock,
        unitPrice: product.price,
        onDecrease: () =>
            shop.setCartQuantity(product, shop.cartQuantityFor(product) - 1),
        onIncrease: () => shop.addToCart(product),
        onAdd: () => shop.addToCart(product),
        onViewCart: () => _openCart(context),
      ),
    );
  }

  void _openCart(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }
}
