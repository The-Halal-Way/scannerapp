import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class SearchCatalogHeader extends StatelessWidget {
  const SearchCatalogHeader({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onFilterTap,
    required this.onCartTap,
    required this.activeFilterCount,
    required this.cartCount,
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final VoidCallback onFilterTap;
  final VoidCallback onCartTap;
  final int activeFilterCount;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.brand.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'MED CLUB  /  CATALOG',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.brand,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton.outlined(
                    tooltip: 'Open cart',
                    onPressed: onCartTap,
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: -2,
                      top: -4,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 19,
                          minHeight: 19,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: colors.coral,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.canvas, width: 2),
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
          const SizedBox(height: 18),
          Text(
            'Find care,\nstock smarter.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              height: 1.08,
              fontWeight: FontWeight.w900,
              letterSpacing: -.7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Everything your pharmacy needs, all in one place.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border.all(color: colors.stroke),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: .05),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: colors.brand),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: onQueryChanged,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Medicine, brand, category...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (controller.text.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear search',
                          onPressed: onClearQuery,
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: FilledButton(
                      onPressed: onFilterTap,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(54, 54),
                        maximumSize: const Size(54, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Icon(Icons.tune_rounded, size: 23),
                    ),
                  ),
                  if (activeFilterCount > 0)
                    Positioned(
                      right: -3,
                      top: -4,
                      child: Container(
                        width: 19,
                        height: 19,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.coral,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.canvas, width: 2),
                        ),
                        child: Text(
                          '$activeFilterCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
