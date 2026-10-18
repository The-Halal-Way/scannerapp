import 'package:flutter/material.dart';
import 'package:scannerapp/feature/catalog/data/models/catalog_category.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_category_card.dart';

class DashboardCategoryGrid extends StatelessWidget {
  const DashboardCategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  final List<CatalogCategory> categories;
  final ValueChanged<String>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 60) return const SizedBox.shrink();

        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final maxColumns = textScale > 1.5 ? 2 : 4;
        final fittingColumns = ((constraints.maxWidth + 20) / 76).floor();
        final safeColumns = fittingColumns < maxColumns
            ? fittingColumns
            : maxColumns;
        final columns = categories.length < safeColumns
            ? categories.length
            : safeColumns;
        final spacing = columns >= 4 ? 12.0 : 20.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: 12,
          children: [
            for (final category in categories)
              SizedBox(
                width: itemWidth,
                child: DashboardCategoryCard(
                  category: category,
                  labelMaxLines: 2,
                  onTap: () => onCategoryTap?.call(category.id),
                ),
              ),
          ],
        );
      },
    );
  }
}
