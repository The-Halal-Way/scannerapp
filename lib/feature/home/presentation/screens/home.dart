import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/config/router/app_router.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:scannerapp/feature/favorites/presentation/screens/favorite_products_screen.dart';
import 'package:scannerapp/feature/home/presentation/widgets/home_navbar.dart';
import 'package:scannerapp/feature/inbox/presentation/screens/inbox_screen.dart';
import 'package:scannerapp/feature/orders/presentation/screens/orders_screen.dart';
import 'package:scannerapp/feature/product/presentation/screens/product_detail_screen.dart';
import 'package:scannerapp/feature/search/presentation/screens/search_screen.dart';
import 'package:scannerapp/feature/settings/presentation/screens/settings_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentPage;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(0, 4);
    _pages = [
      DashboardScreen(
        onSearchTap: () => _openCatalog(focusSearch: true),
        onVoiceSearchTap: () => _openCatalog(startVoiceSearch: true),
        onOffersTap: () => _openCatalog(onlyOffers: true),
        onFavoritesTap: _openFavorites,
        onOrdersTap: () => _changePage(1),
        onProfileTap: _openProfile,
        onCompanyTap: (id) => _openCatalog(companyId: id),
        onProductTap: _openProduct,
      ),
      const OrdersScreen(),
      CartScreen(embedded: true, onContinue: () => _changePage(0)),
      const InboxScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPage, children: _pages),
      bottomNavigationBar: HomeNavbar(
        currentPage: _currentPage,
        onPageChange: _changePage,
        cartCount: context.select<ShopProvider, int>((shop) => shop.cartCount),
      ),
    );
  }

  void _changePage(int index) {
    if (_currentPage == index) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _currentPage = index);
  }

  void _openFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FavoriteProductsScreen()),
    );
  }

  void _openProfile() {
    Navigator.of(context).pushNamed(AppRouteName.profileDetails);
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _openCatalog({
    String? categoryId,
    String? companyId,
    bool onlyOffers = false,
    bool focusSearch = false,
    bool startVoiceSearch = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchScreen(
          initialCategoryId: categoryId,
          initialCompanyId: companyId,
          initialOnlyOffers: onlyOffers,
          focusSearchOnOpen: focusSearch,
          startVoiceSearchOnOpen: startVoiceSearch,
          onProductTap: _openProduct,
        ),
      ),
    );
  }
}
