import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class ProductDetailHero extends StatelessWidget {
  const ProductDetailHero({
    super.key,
    required this.product,
    required this.cartCount,
    required this.onBack,
    required this.onCartTap,
  });

  final Product product;
  final int cartCount;
  final VoidCallback onBack;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final category = DemoCatalog.categoryById(product.categoryId);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      height: 365 + topPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
        child: Stack(
          children: [
            Positioned(
              width: 280,
              height: 280,
              right: -95,
              top: 35,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .065),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              width: 200,
              height: 200,
              left: -95,
              bottom: -60,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.cyan.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: topPadding + 10,
              left: 18,
              right: 18,
              child: Row(
                children: [
                  _HeroIconButton(icon: AppIcons.back, onTap: onBack),
                  const Spacer(),
                  const Text(
                    'PRODUCT DETAILS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .15,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _HeroIconButton(icon: AppIcons.bag, onTap: onCartTap),
                      if (cartCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: colors.coral,
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                color: colors.heroMiddle,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cartCount > 99 ? '99+' : '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: topPadding + 75,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 238,
                  height: 238,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(39),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .18),
                    ),
                  ),
                  child: ProductVisual(
                    name: product.name,
                    category: category.name,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                children: [
                  Flexible(
                    child: _HeroLabel(
                      icon: AppIcons.verified,
                      text: 'TRUSTED SUPPLY',
                    ),
                  ),
                  if (product.discountPercent > 0) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: _HeroLabel(
                        icon: AppIcons.offer,
                        text: 'SAVE ${product.discountPercent}%',
                        highlighted: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _HeroLabel extends StatelessWidget {
  const _HeroLabel({
    required this.icon,
    required this.text,
    this.highlighted = false,
  });

  final IconData icon;
  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: highlighted
            ? context.appColors.coral
            : Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
