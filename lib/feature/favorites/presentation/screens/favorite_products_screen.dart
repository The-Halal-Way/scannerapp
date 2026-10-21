import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/screens/product_detail_screen.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';

class FavoriteProductsScreen extends StatelessWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final favorites = shop.favoriteProducts;
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(title: const Text('Favorite products')),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.favorite, size: 52, color: colors.coral),
                    const SizedBox(height: 14),
                    Text(
                      'No favorites yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the heart on a product to keep it here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 24),
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 9),
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ProductResultCard(
                  key: ValueKey(product.id),
                  product: product,
                  cartQuantity: shop.cartQuantityFor(product),
                  isFavorite: true,
                  onTap: () => _openProduct(context, product),
                  onAdd: () => shop.addToCart(product),
                  onDecrease: () => shop.setCartQuantity(
                    product,
                    shop.cartQuantityFor(product) - 1,
                  ),
                  onIncrease: () => shop.addToCart(product),
                  onFavorite: () => shop.toggleFavorite(product),
                );
              },
            ),
    );
  }

  void _openProduct(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }
}
