import 'package:flutter/foundation.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get lineTotal => product.price * quantity;
}

enum OrderStatus { placed, onTheWay, delivered }

class ShopOrder {
  const ShopOrder({
    required this.id,
    required this.placedAt,
    required this.items,
    required this.deliveryFee,
    required this.status,
  });

  final String id;
  final DateTime placedAt;
  final List<CartItem> items;
  final int deliveryFee;
  final OrderStatus status;

  int get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  int get total => subtotal + deliveryFee;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Session-only store. Closing the app resets the cart and order changes.
class ShopProvider extends ChangeNotifier {
  final Map<String, int> _cartQuantities = {};
  final List<ShopOrder> _orders = [
    ShopOrder(
      id: 'MC-24108',
      placedAt: DateTime.now().subtract(const Duration(days: 2)),
      items: [
        CartItem(product: DemoCatalog.products[0], quantity: 4),
        CartItem(product: DemoCatalog.products[1], quantity: 2),
      ],
      deliveryFee: 0,
      status: OrderStatus.onTheWay,
    ),
    ShopOrder(
      id: 'MC-24076',
      placedAt: DateTime.now().subtract(const Duration(days: 12)),
      items: [
        CartItem(product: DemoCatalog.products[2], quantity: 3),
        CartItem(product: DemoCatalog.products[5], quantity: 3),
      ],
      deliveryFee: 0,
      status: OrderStatus.delivered,
    ),
  ];

  List<CartItem> get cartItems => List.unmodifiable(
    _cartQuantities.entries.map(
      (entry) => CartItem(
        product: DemoCatalog.productById(entry.key),
        quantity: entry.value,
      ),
    ),
  );

  List<ShopOrder> get orders => List.unmodifiable(_orders);
  int get cartCount =>
      _cartQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  int get cartSubtotal =>
      cartItems.fold(0, (sum, item) => sum + item.lineTotal);
  int get deliveryFee => cartSubtotal == 0 || cartSubtotal >= 1000 ? 0 : 60;
  int get cartTotal => cartSubtotal + deliveryFee;

  int cartQuantityFor(Product product) => _cartQuantities[product.id] ?? 0;

  void addToCart(Product product, {int quantity = 1}) {
    if (quantity <= 0 || product.stock <= 0) return;
    final next = (cartQuantityFor(product) + quantity).clamp(0, product.stock);
    if (next == cartQuantityFor(product)) return;
    _cartQuantities[product.id] = next;
    notifyListeners();
  }

  void setCartQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }
    final next = quantity.clamp(1, product.stock);
    if (next == cartQuantityFor(product)) return;
    _cartQuantities[product.id] = next;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cartQuantities.remove(product.id) != null) notifyListeners();
  }

  ShopOrder? placeOrder() {
    if (_cartQuantities.isEmpty) return null;
    final order = ShopOrder(
      id: 'MC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      placedAt: DateTime.now(),
      items: cartItems,
      deliveryFee: deliveryFee,
      status: OrderStatus.placed,
    );
    _orders.insert(0, order);
    _cartQuantities.clear();
    notifyListeners();
    return order;
  }
}
