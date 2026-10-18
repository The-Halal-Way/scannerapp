import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/config/theme/app_theme.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('compact product result fits a ${width.toInt()}px phone', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.light(context),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  children: [
                    ProductResultCard(
                      product: DemoCatalog.productById('p17'),
                      onTap: () {},
                      onAdd: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(ProductResultCard)).height,
        closeTo(126, 1),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
