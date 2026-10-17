import 'package:flutter/material.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/home/presentation/screens/home.dart';
import 'package:scannerapp/feature/profile/presentation/screens/profile_details_screen.dart';

abstract final class AppRouteName {
  static const home = '/';
  static const cart = '/cart';
  static const profileDetails = '/profile';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRouteName.cart => const CartScreen(),
      AppRouteName.profileDetails => const ProfileDetailsScreen(),
      _ => const Home(),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
