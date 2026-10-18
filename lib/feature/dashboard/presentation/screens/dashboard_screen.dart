import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_category_grid.dart';
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
          padding: EdgeInsets.only(bottom: 17.h),
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
              SizedBox(height: 11.h),
              DashboardPromoBanner(
                onExploreTap: onOffersTap ?? onSearchTap,
                onBrowseTap: onSearchTap,
              ),
              SizedBox(height: 16.h),
              DashboardSectionHeader(
                title: 'Manufacturers',
                icon: AppIcons.company,
                accent: colors.cyan,
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 3.5.h),
              _horizontalList(
                height: 58.h,
                count: DemoCatalog.companies.length,
                itemBuilder: (index) {
                  final company = DemoCatalog.companies[index];
                  return DashboardCompanyCard(
                    company: company,
                    onTap: () => onCompanyTap?.call(company.id),
                  );
                },
              ),
              SizedBox(height: 16.h),
              DashboardSectionHeader(
                title: 'Categories',
                icon: AppIcons.category,
                accent: colors.violet,
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 3.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: DashboardCategoryGrid(
                  categories: DemoCatalog.categories,
                  onCategoryTap: onCategoryTap,
                ),
              ),
              SizedBox(height: 15.h),
              DashboardSectionHeader(
                title: 'Popular picks',
                icon: AppIcons.sparkle,
                accent: colors.coral,
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 3.5.h),
              _productList(context, popular, shop),
              SizedBox(height: 16.h),
              DashboardSectionHeader(
                title: 'Special offers',
                icon: AppIcons.offer,
                accent: colors.warning,
                onActionTap: onOffersTap ?? onSearchTap,
              ),
              SizedBox(height: 3.5.h),
              _productList(context, offers, shop),
              SizedBox(height: 16.h),
              DashboardSectionHeader(
                title: 'All products',
                icon: AppIcons.medicine,
                accent: colors.success,
                actionLabel: 'Browse all',
                onActionTap: onSearchTap,
              ),
              SizedBox(height: 3.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
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
                        mainAxisSpacing: 8.h,
                        mainAxisExtent: 186.h,
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
        padding: EdgeInsets.symmetric(horizontal: 13.w),
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
      height: 186.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        itemCount: products.length,
        separatorBuilder: (_, _) => SizedBox(width: 11.w),
        itemBuilder: (context, index) => SizedBox(
          width: 127.w,
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
      companyName: DemoCatalog.companyById(product.companyId).shortName,
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
