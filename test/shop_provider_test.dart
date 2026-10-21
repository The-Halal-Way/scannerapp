import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';

void main() {
  test('favorites and recent purchases update within the session', () {
    final shop = ShopProvider();
    addTearDown(shop.dispose);
    final product = DemoCatalog.productById('p17');

    expect(shop.favoriteProducts, isEmpty);
    shop.toggleFavorite(product);
    expect(shop.isFavorite(product), isTrue);
    expect(shop.favoriteProducts, [product]);
    shop.toggleFavorite(product);
    expect(shop.favoriteCount, 0);

    shop.addToCart(product, quantity: 2);
    shop.placeOrder();
    expect(shop.recentPurchases.first, product);
    shop.addToCart(product);
    shop.placeOrder();
    expect(
      shop.recentPurchases.where((item) => item.id == product.id),
      hasLength(1),
    );
  });

  test(
    'cart quantities, delivery, and placed orders stay in session state',
    () {
      final shop = ShopProvider();
      final first = DemoCatalog.products.first;
      final second = DemoCatalog.products[1];

      expect(shop.cartCount, 0);
      expect(shop.orders.length, 2);

      shop.addToCart(first, quantity: 4);
      expect(shop.cartQuantityFor(first), 4);
      expect(shop.cartSubtotal, first.price * 4);
      expect(shop.deliveryFee, 60);

      shop.addToCart(second);
      expect(shop.cartCount, 5);
      expect(shop.deliveryFee, 0);

      final order = shop.placeOrder();
      expect(order, isNotNull);
      expect(order!.itemCount, 5);
      expect(order.status, OrderStatus.placed);
      expect(shop.orders.first, same(order));
      expect(shop.cartCount, 0);
      expect(shop.cartTotal, 0);
    },
  );

  test('cart cannot exceed available stock', () {
    final shop = ShopProvider();
    final product = DemoCatalog.products.first;

    shop.addToCart(product, quantity: product.stock + 10);
    expect(shop.cartQuantityFor(product), product.stock);

    shop.setCartQuantity(product, 0);
    expect(shop.cartCount, 0);
  });
}
