import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_product_item.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_section_header.dart';

class DashboardProductSection extends StatelessWidget {
  const DashboardProductSection({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.products,
    this.onActionTap,
    this.onProductTap,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final List<Product> products;
  final VoidCallback? onActionTap;
  final ValueChanged<Product>? onProductTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          DashboardSectionHeader(
            title: title,
            icon: icon,
            accent: accent,
            onActionTap: onActionTap,
          ),
          SizedBox(height: 3.5.h),
          SizedBox(
            height: 186.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              itemCount: products.length,
              separatorBuilder: (_, _) => SizedBox(width: 11.w),
              itemBuilder: (context, index) => SizedBox(
                width: 127.w,
                child: DashboardProductItem(
                  product: products[index],
                  onProductTap: onProductTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
