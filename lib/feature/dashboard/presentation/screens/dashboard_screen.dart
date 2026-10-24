import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/core/widgets/app_brand_footer.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_company_section.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_item.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_section.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_promo_banner.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_section_header.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_search_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.onSearchTap,
    this.onVoiceSearchTap,
    this.onOffersTap,
    this.onFavoritesTap,
    this.onOrdersTap,
    this.onProfileTap,
    this.onCompanyTap,
    this.onProductTap,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onVoiceSearchTap;
  final VoidCallback? onOffersTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onCompanyTap;
  final ValueChanged<Product>? onProductTap;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final colors = context.appColors;
    final topProducts = [
      'p17',
      'p03',
      'p07',
      'p10',
    ].map(DemoCatalog.productById).toList();

    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DashboardHeader(
              name: context.watch<GlobalService>().username,
              favoriteCount: shop.favoriteCount,
              onSearchTap: onSearchTap,
              onFavoritesTap: onFavoritesTap,
              onProfileTap: onProfileTap,
            ),
            Expanded(
              child: CustomScrollView(
                key: const PageStorageKey('dashboard-scroll'),
                slivers: [
                  SliverList.list(
                    children: [
                      DashboardSearchBar(
                        onTap: onSearchTap,
                        onVoiceTap: onVoiceSearchTap,
                      ),
                      SizedBox(height: 11.h),
                      DashboardPromoBanner(
                        onExploreTap: onOffersTap ?? onSearchTap,
                        onBrowseTap: onSearchTap,
                      ),
                      DashboardCompanySection(
                        onCompanyTap: onCompanyTap,
                        onBrowseTap: onSearchTap,
                      ),
                      DashboardProductSection(
                        title: 'Recent Purchases',
                        icon: AppIcons.receipt,
                        accent: colors.violet,
                        products: shop.recentPurchases,
                        onActionTap: onOrdersTap,
                        onProductTap: onProductTap,
                      ),
                      DashboardProductSection(
                        title: 'Top products',
                        icon: AppIcons.sparkle,
                        accent: colors.cyan,
                        products: topProducts,
                        onActionTap: onSearchTap,
                        onProductTap: onProductTap,
                      ),
                      DashboardProductSection(
                        title: 'Popular picks',
                        icon: AppIcons.sparkle,
                        accent: colors.coral,
                        products: DemoCatalog.products
                            .where((p) => p.isPopular)
                            .toList(),
                        onActionTap: onSearchTap,
                        onProductTap: onProductTap,
                      ),
                      DashboardProductSection(
                        title: 'Special offers',
                        icon: AppIcons.offer,
                        accent: colors.warning,
                        products: DemoCatalog.products
                            .where((p) => p.isOffer)
                            .toList(),
                        onActionTap: onOffersTap ?? onSearchTap,
                        onProductTap: onProductTap,
                      ),
                      SizedBox(height: 16.h),
                      DashboardSectionHeader(
                        title: 'All products',
                        icon: AppIcons.medicine,
                        accent: colors.success,
                        actionLabel: 'Browse all',
                        onActionTap: onSearchTap,
                      ),
                      SizedBox(height: 3.5.h),
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(13.w, 0, 13.w, 17.h),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.crossAxisExtent;
                        final columns = width >= 850
                            ? 4
                            : width >= 550
                            ? 3
                            : 2;
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 8.h,
                                mainAxisExtent: 186.h,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => DashboardProductItem(
                              product: DemoCatalog.products[index],
                              onProductTap: onProductTap,
                            ),
                            childCount: DemoCatalog.products.length,
                          ),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: AppBrandFooter()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
