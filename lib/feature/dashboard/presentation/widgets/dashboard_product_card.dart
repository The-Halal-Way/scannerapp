import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_visual.dart';

class DashboardProductCard extends StatelessWidget {
  const DashboardProductCard({
    super.key,
    required this.product,
    required this.categoryName,
    required this.companyName,
    required this.cartQuantity,
    this.onTap,
    this.onAddTap,
  });

  final Product product;
  final String categoryName;
  final String companyName;
  final int cartQuantity;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(17.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Container(
          padding: EdgeInsets.all(7.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(color: colors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 78.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProductVisual(
                        name: product.name,
                        category: categoryName,
                        compact: true,
                      ),
                    ),
                    if (product.isOffer && product.discountPercent > 0)
                      Positioned(
                        top: 5.h,
                        left: 5.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.coral,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.brand,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                product.genericName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9.sp,
                  color: colors.textMuted,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (product.originalPrice > product.price)
                          Text(
                            '৳${product.originalPrice}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colors.textMuted,
                                  fontSize: 8.5.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        Text(
                          '৳${product.price}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Add ${product.name} to cart',
                    child: InkWell(
                      onTap: onAddTap,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: cartQuantity > 0
                              ? colors.success
                              : colors.brand,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          cartQuantity > 0 ? AppIcons.addToCart : AppIcons.add,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
