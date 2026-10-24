import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_company_card.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_section_header.dart';

class DashboardCompanySection extends StatelessWidget {
  const DashboardCompanySection({
    super.key,
    this.onCompanyTap,
    this.onBrowseTap,
  });

  final ValueChanged<String>? onCompanyTap;
  final VoidCallback? onBrowseTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 16.h),
    child: Column(
      children: [
        DashboardSectionHeader(
          title: 'Manufacturers',
          icon: AppIcons.company,
          accent: context.appColors.cyan,
          onActionTap: onBrowseTap,
        ),
        SizedBox(height: 3.5.h),
        SizedBox(
          height: 69.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            itemCount: DemoCatalog.companies.length,
            separatorBuilder: (_, _) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final company = DemoCatalog.companies[index];
              return DashboardCompanyCard(
                company: company,
                onTap: () => onCompanyTap?.call(company.id),
              );
            },
          ),
        ),
      ],
    ),
  );
}
