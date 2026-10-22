import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/product/presentation/screens/product_detail_screen.dart';
import 'package:scannerapp/feature/search/presentation/screens/search_screen.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';

void main() {
  testWidgets('buyer can find a product and add it from the detail screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final shop = ShopProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: shop,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: AppTheme.light(context),
            home: const SearchScreen(),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField), 'Relivo');
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(ProductResultCard), findsOneWidget);

    await tester.tap(find.byType(ProductResultCard));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ProductDetailScreen), findsOneWidget);

    await tester.tap(find.textContaining('Add to cart'));
    await tester.pumpAndSettle();
    expect(shop.cartCount, 1);
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(shop.cartCount, 1);
    expect(shop.cartUnitCount, 2);
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    expect(shop.cartCount, 1);
    expect(shop.cartUnitCount, 1);
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pump();
    expect(shop.isFavorite(DemoCatalog.products.first), isTrue);
    expect(tester.takeException(), isNull);
  });
}
