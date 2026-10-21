import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_picker_sheet.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_ticket_card.dart';
import 'package:scannerapp/main.dart';

void main() {
  testWidgets('coupon can be entered, applied, removed, and checked out', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Coupons for you'), findsOneWidget);
    expect(find.text('CARE10'), findsOneWidget);
    final shop = tester
        .element(find.byType(CouponTicketCard).first)
        .read<ShopProvider>();
    shop.addToCart(DemoCatalog.products.first, quantity: 4);
    await tester.pump();
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Apply a coupon'));
    await tester.tap(find.text('Apply a coupon'));
    await tester.pumpAndSettle();
    expect(find.byType(CouponPickerSheet), findsOneWidget);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(find.text('Apply').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'invalid');
    await tester.tap(find.text('Apply'));
    await tester.pump();
    expect(find.text('This coupon code is not valid.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'care10');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(shop.couponDiscount, 82);
    expect(find.text('CARE10 applied'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove coupon'));
    await tester.pump();
    expect(shop.appliedCoupon, isNull);

    await tester.tap(find.text('Apply a coupon'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply coupon').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Order placed!'), findsOneWidget);
    expect(shop.orders.first.discount, 82);
    expect(shop.orders.first.total, 798);
    expect(tester.takeException(), isNull);
  });
}
