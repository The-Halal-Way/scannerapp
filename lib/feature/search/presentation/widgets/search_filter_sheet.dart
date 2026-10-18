import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/search/presentation/providers/search_filter_provider.dart';

class SearchFilterSheet extends StatelessWidget {
  const SearchFilterSheet({super.key, required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final filters = context.watch<SearchFilterProvider>();

    return Container(
      height: MediaQuery.sizeOf(context).height * .84,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: colors.strokeStrong,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 21, 22, 13),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Refine results',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: filters.resetFilters,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.stroke),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 21, 22, 22),
                children: [
                  _FilterHeading(title: 'Category', icon: AppIcons.category),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 8,
                    runSpacing: 9,
                    children: [
                      _ChoicePill(
                        label: 'All products',
                        selected: filters.categoryId == null,
                        onTap: () => filters.setCategory(null),
                      ),
                      for (final category in DemoCatalog.categories)
                        _ChoicePill(
                          label: category.name,
                          selected: filters.categoryId == category.id,
                          onTap: () => filters.setCategory(category.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _FilterHeading(title: 'Company', icon: AppIcons.company),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 8,
                    runSpacing: 9,
                    children: [
                      _ChoicePill(
                        label: 'Any company',
                        selected: filters.companyId == null,
                        onTap: () => filters.setCompany(null),
                      ),
                      for (final company in DemoCatalog.companies)
                        _ChoicePill(
                          label: company.name,
                          selected: filters.companyId == company.id,
                          onTap: () => filters.setCompany(company.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _FilterHeading(title: 'Price range', icon: AppIcons.payment),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '৳${filters.priceRange.start.round()}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      Text(
                        '৳${filters.priceRange.end.round()}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: filters.priceRange,
                    min: 0,
                    max: filters.maxPrice,
                    divisions: (filters.maxPrice / 50).round(),
                    labels: RangeLabels(
                      '৳${filters.priceRange.start.round()}',
                      '৳${filters.priceRange.end.round()}',
                    ),
                    onChanged: filters.setPriceRange,
                  ),
                  const SizedBox(height: 7),
                  _FilterHeading(title: 'Availability', icon: AppIcons.package),
                  const SizedBox(height: 10),
                  _ToggleRow(
                    title: 'In stock only',
                    subtitle: 'Ready to add to your next order',
                    value: filters.onlyInStock,
                    onChanged: filters.setOnlyInStock,
                  ),
                  const SizedBox(height: 9),
                  _ToggleRow(
                    title: 'Special offers',
                    subtitle: 'Current savings and deals',
                    value: filters.onlyOffers,
                    onChanged: filters.setOnlyOffers,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onApply,
                  icon: const Icon(AppIcons.check),
                  label: Text('Show ${filters.results.length} products'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterHeading extends StatelessWidget {
  const _FilterHeading({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.brand),
        const SizedBox(width: 9),
        Text(title, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: selected ? colors.brand : colors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
