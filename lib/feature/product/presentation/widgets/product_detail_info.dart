import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final company = DemoCatalog.companyById(product.companyId);
    final category = DemoCatalog.categoryById(product.categoryId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.brand.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  company.shortName,
                  style: TextStyle(
                    color: colors.brand,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  company.name.toUpperCase(),
                  style: TextStyle(
                    color: colors.brand,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: (product.stock > 0 ? colors.success : colors.danger)
                      .withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  product.stock > 0 ? 'IN STOCK' : 'OUT OF STOCK',
                  style: TextStyle(
                    color: product.stock > 0 ? colors.success : colors.danger,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.genericName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.stroke),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .05),
                  blurRadius: 25,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WHOLESALE PRICE',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 8,
                        runSpacing: 3,
                        children: [
                          Text(
                            '৳${product.price}',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 30,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (product.originalPrice > product.price) ...[
                            Text(
                              '৳${product.originalPrice}',
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'per ${product.unit}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (product.discountPercent > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: colors.coral.withValues(alpha: .11),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.trending_down_rounded,
                          color: colors.coral,
                          size: 19,
                        ),
                        Text(
                          '${product.discountPercent}% OFF',
                          style: TextStyle(
                            color: colors.coral,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          Text(
            'Product overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 9),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          Text('At a glance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _DetailTile(
                  icon: Icons.category_outlined,
                  label: 'CATEGORY',
                  value: category.name,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'PACK SIZE',
                  value: product.unit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DetailTile(
                  icon: Icons.business_outlined,
                  label: 'MANUFACTURER',
                  value: company.name,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailTile(
                  icon: Icons.local_shipping_outlined,
                  label: 'AVAILABLE',
                  value: '${product.stock} packs',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.brand, size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                    letterSpacing: .7,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
