import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_card.dart';

class DashboardProductItem extends StatelessWidget {
  const DashboardProductItem({
    super.key,
    required this.product,
    this.onProductTap,
  });

  final Product product;
  final ValueChanged<Product>? onProductTap;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    return DashboardProductCard(
      product: product,
      categoryName: DemoCatalog.categoryById(product.categoryId).name,
      companyName: DemoCatalog.companyById(product.companyId).shortName,
      cartQuantity: shop.cartQuantityFor(product),
      isFavorite: shop.isFavorite(product),
      onTap: () => onProductTap?.call(product),
      onFavoriteTap: () => shop.toggleFavorite(product),
      onDecreaseTap: () =>
          shop.setCartQuantity(product, shop.cartQuantityFor(product) - 1),
      onIncreaseTap: () => shop.addToCart(product),
      onAddTap: () => shop.addToCart(product),
    );
  }
}
