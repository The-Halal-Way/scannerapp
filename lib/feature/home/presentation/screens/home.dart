import 'package:flutter/material.dart';
import 'package:scannerapp/config/router/app_router.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/screens/dashboard_screen.dart';
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
  int _catalogVersion = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(0, 4);
    _pages = [
      DashboardScreen(
        onSearchTap: _openCatalog,
        onOffersTap: () => _openCatalog(onlyOffers: true),
        onCartTap: _openCart,
        onProfileTap: _openProfile,
        onCategoryTap: (id) => _openCatalog(categoryId: id),
        onCompanyTap: (id) => _openCatalog(companyId: id),
        onProductTap: _openProduct,
      ),
      const OrdersScreen(),
      SearchScreen(onProductTap: _openProduct),
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
      ),
    );
  }

  void _changePage(int index) {
    if (_currentPage == index) return;
    setState(() => _currentPage = index);
  }

  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
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
  }) {
    setState(() {
      _catalogVersion++;
      _pages[2] = SearchScreen(
        key: ValueKey(_catalogVersion),
        initialCategoryId: categoryId,
        initialCompanyId: companyId,
        initialOnlyOffers: onlyOffers,
        onProductTap: _openProduct,
      );
      _currentPage = 2;
    });
  }
}
