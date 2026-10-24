import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/router/app_router.dart';
import 'package:scannerapp/config/theme/app_theme.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/widgets/app_brand.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/inbox/presentation/providers/inbox_provider.dart';
import 'package:scannerapp/feature/settings/presentation/providers/settings_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShopProvider>(create: (_) => ShopProvider()),
        ChangeNotifierProvider<GlobalService>.value(
          value: GlobalService.instance,
        ),
        ChangeNotifierProvider<InboxProvider>(create: (_) => InboxProvider()),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          title: AppBranding.name,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(context),
          initialRoute: AppRouteName.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
