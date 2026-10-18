import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('dashboard fits a ${width.toInt()}px phone', (tester) async {
      tester.view.physicalSize = Size(width, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ShopProvider()),
            ChangeNotifierProvider<GlobalService>.value(
              value: GlobalService.instance,
            ),
          ],
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              theme: AppTheme.light(context),
              home: const Scaffold(body: DashboardScreen()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Manufacturers'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
