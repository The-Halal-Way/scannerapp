import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class ProductResultCard extends StatelessWidget {
  const ProductResultCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final company = DemoCatalog.companyById(product.companyId);
    final category = DemoCatalog.categoryById(product.categoryId);

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(8.5),
          decoration: BoxDecoration(
            border: Border.all(color: colors.stroke),
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: .045),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 107,
            child: Row(
              children: [
                SizedBox(
                  width: 95,
                  height: 107,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ProductVisual(
                          name: product.name,
                          category: category.name,
                          compact: true,
                        ),
                      ),
                      if (product.discountPercent > 0)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.coral,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.brand,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        product.genericName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        product.unit,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.textMuted, fontSize: 10),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '৳${product.price}',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                if (product.originalPrice > product.price)
                                  Text(
                                    '৳${product.originalPrice}',
                                    style: TextStyle(
                                      color: colors.textMuted,
                                      fontSize: 9,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 33,
                            height: 33,
                            child: IconButton.filled(
                              tooltip: product.stock > 0
                                  ? 'Add to cart'
                                  : 'Out of stock',
                              onPressed: product.stock > 0 ? onAdd : null,
                              constraints: const BoxConstraints.tightFor(
                                width: 33,
                                height: 33,
                              ),
                              padding: EdgeInsets.zero,
                              style: IconButton.styleFrom(
                                backgroundColor: colors.brand,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: colors.surfaceMuted,
                                disabledForegroundColor: colors.textMuted,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(AppIcons.add, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
