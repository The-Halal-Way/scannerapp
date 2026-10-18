import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_promo_banner.dart';

void main() {
  testWidgets('promo banner advances, swipes, and wraps around', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var offerTaps = 0;
    var browseTaps = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: DashboardPromoBanner(
              onExploreTap: () => offerTaps++,
              onBrowseTap: () => browseTaps++,
            ),
          ),
        ),
      ),
    );

    double currentPage() =>
        tester.widget<PageView>(find.byType(PageView)).controller!.page!;

    expect(currentPage(), 0);
    await tester.tap(find.text('Shop offers'));
    expect(offerTaps, 1);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(currentPage(), closeTo(1, .01));
    await tester.tap(find.text('Browse products'));
    expect(browseTaps, 1);

    await tester.drag(find.byType(PageView), const Offset(-330, 0));
    await tester.pumpAndSettle();
    expect(currentPage(), closeTo(2, .01));

    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(currentPage(), closeTo(0, .01));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
