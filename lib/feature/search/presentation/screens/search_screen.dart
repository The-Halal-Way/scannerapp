import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/cart/presentation/screens/cart_screen.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/screens/product_detail_screen.dart';
import 'package:scannerapp/feature/search/presentation/providers/search_filter_provider.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';
import 'package:scannerapp/feature/search/presentation/widgets/search_catalog_header.dart';
import 'package:scannerapp/feature/search/presentation/widgets/search_category_rail.dart';
import 'package:scannerapp/feature/search/presentation/widgets/search_filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialCategoryId,
    this.initialCompanyId,
    this.initialOnlyOffers = false,
    this.onProductTap,
  });

  final String? initialCategoryId;
  final String? initialCompanyId;
  final bool initialOnlyOffers;
  final ValueChanged<Product>? onProductTap;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchFilterProvider _filters;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filters = SearchFilterProvider(
      initialCategoryId: widget.initialCategoryId,
      initialCompanyId: widget.initialCompanyId,
      initialOnlyOffers: widget.initialOnlyOffers,
    );
    _searchController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategoryId != widget.initialCategoryId) {
      _filters.setCategory(widget.initialCategoryId);
    }
    if (oldWidget.initialCompanyId != widget.initialCompanyId) {
      _filters.setCompany(widget.initialCompanyId);
    }
    if (oldWidget.initialOnlyOffers != widget.initialOnlyOffers) {
      _filters.setOnlyOffers(widget.initialOnlyOffers);
    }
  }

  @override
  void dispose() {
    _filters.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _filters,
      child: Consumer<SearchFilterProvider>(
        builder: (context, filters, _) {
          final results = filters.results;
          final colors = context.appColors;
          return Scaffold(
            backgroundColor: colors.canvas,
            body: SafeArea(
              bottom: false,
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(
                    child: SearchCatalogHeader(
                      controller: _searchController,
                      onQueryChanged: filters.setQuery,
                      onClearQuery: _clearQuery,
                      onFilterTap: _showFilters,
                      onCartTap: _openCart,
                      activeFilterCount: filters.activeFilterCount,
                      cartCount: context.watch<ShopProvider>().cartCount,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: SearchCategoryRail(
                      selectedId: filters.categoryId,
                      onSelected: filters.setCategory,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _ResultsToolbar(
                      count: results.length,
                      filters: filters,
                    ),
                  ),
                  if (results.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyResults(onClear: _clearAll),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index.isOdd) return const SizedBox(height: 11);
                          final product = results[index ~/ 2];
                          return ProductResultCard(
                            product: product,
                            onTap: () => _openProduct(product),
                            onAdd: () => _addToCart(product),
                          );
                        }, childCount: results.length * 2 - 1),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: _filters,
        child: SearchFilterSheet(onApply: () => Navigator.pop(sheetContext)),
      ),
    );
  }

  void _clearQuery() {
    _searchController.clear();
    _filters.setQuery('');
  }

  void _clearAll() {
    _searchController.clear();
    _filters.clearAll();
  }

  void _openProduct(Product product) {
    final onProductTap = widget.onProductTap;
    if (onProductTap != null) {
      onProductTap(product);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }

  void _addToCart(Product product) {
    final shop = context.read<ShopProvider>();
    final atLimit = shop.cartQuantityFor(product) >= product.stock;
    if (!atLimit) shop.addToCart(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            atLimit
                ? 'Maximum stock already in your cart'
                : '${product.name} added to cart',
          ),
          action: atLimit
              ? null
              : SnackBarAction(label: 'VIEW CART', onPressed: _openCart),
        ),
      );
  }
}

class _ResultsToolbar extends StatelessWidget {
  const _ResultsToolbar({required this.count, required this.filters});

  final int count;
  final SearchFilterProvider filters;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '$count products available',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          PopupMenuButton<CatalogSort>(
            tooltip: 'Sort products',
            onSelected: filters.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: CatalogSort.featured,
                child: Text('Featured'),
              ),
              PopupMenuItem(
                value: CatalogSort.priceLow,
                child: Text('Price: low to high'),
              ),
              PopupMenuItem(
                value: CatalogSort.priceHigh,
                child: Text('Price: high to low'),
              ),
              PopupMenuItem(
                value: CatalogSort.name,
                child: Text('Name: A to Z'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: colors.stroke),
              ),
              child: Row(
                children: [
                  Icon(Icons.swap_vert_rounded, size: 17, color: colors.brand),
                  const SizedBox(width: 3),
                  Text(
                    _sortLabel(filters.sort),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sortLabel(CatalogSort sort) => switch (sort) {
    CatalogSort.featured => 'Featured',
    CatalogSort.priceLow => 'Price ↑',
    CatalogSort.priceHigh => 'Price ↓',
    CatalogSort.name => 'Name',
  };
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.brand.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 40,
              color: colors.brand,
            ),
          ),
          const SizedBox(height: 20),
          Text('No matches yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(
            'Try a different name or loosen your filters to see more products.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Clear search & filters'),
          ),
        ],
      ),
    );
  }
}
