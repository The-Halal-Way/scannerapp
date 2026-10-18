import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/search/presentation/providers/search_filter_provider.dart';
import 'package:scannerapp/feature/search/presentation/widgets/search_category_rail.dart';
import 'package:scannerapp/main.dart';

void main() {
  testWidgets('main sections open from the bottom navigation', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Manufacturers'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Your orders'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('Explore products'), findsOneWidget);

    await tester.tap(find.text('Inbox'));
    await tester.pumpAndSettle();
    expect(find.text('Your updates'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Profile details'), findsOneWidget);
  });

  testWidgets('cart checkout creates an order and shows confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final shop = ShopProvider()
      ..addToCart(DemoCatalog.products.first, quantity: 2);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ShopProvider>.value(value: shop),
          ChangeNotifierProvider<GlobalService>.value(
            value: GlobalService.instance,
          ),
        ],
        child: const MaterialApp(home: CartScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your cart'), findsOneWidget);

    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Order placed!'), findsOneWidget);
    expect(shop.cartCount, 0);
    expect(shop.orders.length, 3);
  });

  testWidgets('offer banner opens the filtered catalog in the Search tab', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shop offers'));
    await tester.pumpAndSettle();

    expect(find.text('Explore products'), findsOneWidget);
    final railContext = tester.element(find.byType(SearchCategoryRail));
    expect(railContext.read<SearchFilterProvider>().onlyOffers, isTrue);
  });
}
