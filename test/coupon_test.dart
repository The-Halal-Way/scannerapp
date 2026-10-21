import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/coupons/data/demo_coupons.dart';

void main() {
  test('coupons enforce minimum spend and cap the savings', () {
    final percentage = DemoCoupons.coupons.first;
    expect(percentage.discountFor(499), 0);
    expect(percentage.discountFor(500), 50);
    expect(percentage.discountFor(3000), 200);

    final fixed = DemoCoupons.coupons[1];
    expect(fixed.discountFor(1199), 0);
    expect(fixed.discountFor(1200), 100);
  });

  test('coupon totals react to quantity changes and are saved with orders', () {
    final shop = ShopProvider();
    addTearDown(shop.dispose);
    final product = DemoCatalog.products.first;

    expect(shop.applyCoupon('CARE10'), isNotNull);
    expect(shop.appliedCoupon, isNull);
    shop.addToCart(product, quantity: 4);
    expect(shop.applyCoupon(' care10 '), isNull);
    expect(shop.couponDiscount, 82);
    expect(shop.cartTotal, 798);
    expect(shop.applyCoupon('INVALID'), isNotNull);
    expect(shop.appliedCoupon!.code, 'CARE10');

    shop.setCartQuantity(product, 2);
    expect(shop.couponDiscount, 0);
    expect(shop.cartTotal, 470);
    shop.setCartQuantity(product, 4);
    final order = shop.placeOrder()!;
    expect(order.couponCode, 'CARE10');
    expect(order.discount, 82);
    expect(order.total, 798);
    expect(shop.appliedCoupon, isNull);
    expect(shop.cartTotal, 0);
  });

  test('only one coupon applies and clearing the cart clears its coupon', () {
    final shop = ShopProvider();
    addTearDown(shop.dispose);
    final product = DemoCatalog.products.first;
    shop.addToCart(product, quantity: 6);
    shop.applyCoupon('CARE10');
    shop.applyCoupon('STOCK100');
    expect(shop.couponDiscount, 100);
    expect(shop.cartTotal, 1130);
    shop.removeCoupon();
    expect(shop.cartTotal, 1230);
    shop.applyCoupon('STOCK100');
    shop.removeFromCart(product);
    expect(shop.appliedCoupon, isNull);
  });
}
