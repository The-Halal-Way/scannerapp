import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:scannerapp/feature/home/presentation/widgets/home_navbar.dart';
import 'package:scannerapp/feature/favorites/presentation/screens/favorite_products_screen.dart';
import 'package:scannerapp/feature/search/presentation/screens/search_screen.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';
import 'package:scannerapp/main.dart';

void main() {
  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('cart badge and header distinguish products from pieces', (
    tester,
  ) async {
    await openApp(tester);
    final shop = tester
        .element(find.byType(DashboardScreen))
        .read<ShopProvider>();
    shop.addToCart(DemoCatalog.products.first, quantity: 5);
    shop.addToCart(DemoCatalog.products[1], quantity: 2);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(HomeNavbar), matching: find.text('2')),
      findsOneWidget,
    );
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('2 products'), findsOneWidget);
    expect(find.text('7 pieces'), findsOneWidget);
  });

  testWidgets('dashboard search and favorites remain usable at the bottom', (
    tester,
  ) async {
    await openApp(tester);
    final searchBar = find.text('Search medicines, brands, essentials');
    final searchIcon = find.byTooltip('Open search');
    expect(searchBar.hitTestable(), findsOneWidget);
    expect(searchIcon.hitTestable(), findsOneWidget);
    final scroll = find.byKey(const PageStorageKey('dashboard-scroll'));
    final scrollable = find
        .descendant(of: scroll, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(100);
    await tester.pumpAndSettle();
    expect(searchBar.hitTestable(), findsNothing);
    expect(searchIcon.hitTestable(), findsOneWidget);
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Open favorites').hitTestable(), findsOneWidget);
    expect(searchBar.hitTestable(), findsNothing);
    expect(searchIcon.hitTestable(), findsOneWidget);
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('favorites and cart counters stay in sync across pages', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(find.text('Search medicines, brands, essentials'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Relivo');
    await tester.pumpAndSettle();

    final card = find.byType(ProductResultCard);
    await tester.ensureVisible(card);
    final shop = tester.element(card).read<ShopProvider>();
    final product = DemoCatalog.products.first;
    expect(find.byTooltip('Increase quantity'), findsNothing);
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pump();
    expect(shop.isFavorite(product), isTrue);

    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pumpAndSettle();
    expect(shop.cartQuantityFor(product), 1);
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(shop.cartQuantityFor(product), 2);
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    expect(shop.cartQuantityFor(product), 1);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open favorites'));
    await tester.pumpAndSettle();
    expect(find.byType(FavoriteProductsScreen), findsOneWidget);
    expect(
      tester
          .widget<ProductResultCard>(find.byType(ProductResultCard))
          .product
          .id,
      product.id,
    );
    await tester.tap(find.byTooltip('Change quantity'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    expect(shop.cartCount, 0);
    expect(find.byTooltip('Increase quantity'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Favorite products'));
    await tester.tap(find.text('Favorite products'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ProductResultCard>(find.byType(ProductResultCard))
          .product
          .id,
      product.id,
    );
    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(shop.favoriteCount, 0);
  });

  testWidgets(
    'dashboard card counters fit and checkout works from the Cart tab',
    (tester) async {
      await openApp(tester);
      final scroll = find
          .descendant(
            of: find.byKey(const PageStorageKey('dashboard-scroll')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Recent Purchases'),
        200,
        scrollable: scroll,
      );
      final card = find.byType(DashboardProductCard).first;
      final addButton = find.descendant(
        of: card,
        matching: find.byTooltip('Add to cart'),
      );
      await tester.scrollUntilVisible(
        addButton.hitTestable(),
        100,
        scrollable: scroll,
      );
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: card,
          matching: find.byTooltip('Increase quantity'),
        ),
      );
      await tester.pump();
      final shop = tester.element(card).read<ShopProvider>();
      expect(shop.cartCount, 1);
      expect(shop.cartUnitCount, 2);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(find.text('Your cart'), findsOneWidget);
      await tester.tap(find.text('Place order'));
      await tester.pumpAndSettle();
      expect(find.text('Order placed!'), findsOneWidget);
      expect(shop.cartCount, 0);
      await tester.tap(find.text('Go to orders'));
      await tester.pumpAndSettle();
      expect(find.text('Your orders'), findsOneWidget);
    },
  );
}
