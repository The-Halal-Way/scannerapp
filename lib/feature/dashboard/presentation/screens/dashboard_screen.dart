import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_category_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_company_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_promo_banner.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_section_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.onSearchTap,
    this.onOffersTap,
    this.onCartTap,
    this.onProfileTap,
    this.onCategoryTap,
    this.onCompanyTap,
    this.onProductTap,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onOffersTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onCategoryTap;
  final ValueChanged<String>? onCompanyTap;
  final ValueChanged<Product>? onProductTap;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final colors = context.appColors;
    final popular = DemoCatalog.products
        .where((product) => product.isPopular)
        .toList();
    final offers = DemoCatalog.products
        .where((product) => product.isOffer)
        .toList();

    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(
                name: context.watch<GlobalService>().username,
                cartCount: shop.cartCount,
                onSearchTap: onSearchTap,
                onCartTap: onCartTap,
                onProfileTap: onProfileTap,
              ),
              SizedBox(height: 21.h),
              DashboardPromoBanner(onExploreTap: onOffersTap ?? onSearchTap),
              SizedBox(height: 32.h),
              DashboardSectionHeader(
                title: 'Our partners',
                subtitle: 'Brands you can count on',
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 15.h),
              _horizontalList(
                height: 67.h,
                count: DemoCatalog.companies.length,
                itemBuilder: (index) {
                  final company = DemoCatalog.companies[index];
                  return DashboardCompanyCard(
                    name: company.name,
                    index: index,
                    onTap: () => onCompanyTap?.call(company.id),
                  );
                },
              ),
              SizedBox(height: 30.h),
              DashboardSectionHeader(
                title: 'Categories',
                subtitle: 'Find just what you need',
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 16.h),
              _horizontalList(
                height: 112.h,
                count: DemoCatalog.categories.length,
                itemBuilder: (index) {
                  final category = DemoCatalog.categories[index];
                  return DashboardCategoryCard(
                    name: category.name,
                    index: index,
                    onTap: () => onCategoryTap?.call(category.id),
                  );
                },
              ),
              SizedBox(height: 29.h),
              DashboardSectionHeader(
                title: 'Popular right now',
                subtitle: 'Pharmacy favorites',
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 15.h),
              _productList(context, popular, shop),
              SizedBox(height: 30.h),
              DashboardSectionHeader(
                title: 'Special offers',
                subtitle: 'More value for your shelf',
                onActionTap: onOffersTap ?? onSearchTap,
              ),
              SizedBox(height: 15.h),
              _productList(context, offers, shop),
              SizedBox(height: 30.h),
              DashboardSectionHeader(
                title: 'Explore products',
                subtitle: 'Curated for your pharmacy',
                actionLabel: 'Browse all',
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 850
                        ? 4
                        : constraints.maxWidth >= 550
                        ? 3
                        : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: DemoCatalog.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        mainAxisExtent: 252.h,
                      ),
                      itemBuilder: (context, index) => _buildProductCard(
                        context,
                        DemoCatalog.products[index],
                        shop,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horizontalList({
    required double height,
    required int count,
    required Widget Function(int) itemBuilder,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: count,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) => itemBuilder(index),
      ),
    );
  }

  Widget _productList(
    BuildContext context,
    List<Product> products,
    ShopProvider shop,
  ) {
    return SizedBox(
      height: 252.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: products.length,
        separatorBuilder: (_, _) => SizedBox(width: 11.w),
        itemBuilder: (context, index) => SizedBox(
          width: 165.w,
          child: _buildProductCard(context, products[index], shop),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    ShopProvider shop,
  ) {
    return DashboardProductCard(
      product: product,
      categoryName: DemoCatalog.categoryById(product.categoryId).name,
      companyName: DemoCatalog.companyById(product.companyId).name,
      cartQuantity: shop.cartQuantityFor(product),
      onTap: () => onProductTap?.call(product),
      onAddTap: () {
        shop.addToCart(product);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${product.name} added to cart'),
              duration: const Duration(seconds: 2),
              action: onCartTap == null
                  ? null
                  : SnackBarAction(label: 'View cart', onPressed: onCartTap!),
            ),
          );
      },
    );
  }
}
