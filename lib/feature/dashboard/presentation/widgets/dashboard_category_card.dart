import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/catalog/data/models/catalog_category.dart';

class DashboardCategoryCard extends StatelessWidget {
  const DashboardCategoryCard({
    super.key,
    required this.category,
    required this.labelMaxLines,
    this.onTap,
  });

  final CatalogCategory category;
  final int labelMaxLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final (baseAccent, symbol) = _appearance(context.appColors);
    final accent = isDark
        ? Color.lerp(baseAccent, Colors.white, .42)!
        : baseAccent;

    return Semantics(
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      label: '${category.name}. ${category.subtitle}',
      child: Tooltip(
        message: category.name,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final surfaceSize = (constraints.maxWidth - 4).clamp(56.0, 72.0);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: surfaceSize,
                    height: surfaceSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(
                            isDark
                                ? scheme.surfaceContainerHighest
                                : scheme.surface,
                            accent,
                            isDark ? .16 : .09,
                          )!,
                          isDark ? scheme.surfaceContainerLow : scheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color.lerp(
                          scheme.outlineVariant,
                          accent,
                          isDark ? .34 : .24,
                        )!,
                        width: .8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: isDark ? .18 : .12),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: surfaceSize * .68,
                          height: surfaceSize * .68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(
                              alpha: isDark ? .13 : .075,
                            ),
                            border: Border.all(
                              color: accent.withValues(alpha: .14),
                            ),
                          ),
                        ),
                        Icon(symbol, color: accent, size: surfaceSize * .39),
                        PositionedDirectional(
                          top: 9,
                          end: 10,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: .72),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    maxLines: scale > 1.4 ? labelMaxLines + 1 : labelMaxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontVariations: const [FontVariation('wght', 600)],
                      height: 1.25,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  (Color, IconData) _appearance(AppThemeColors colors) => switch (category.id) {
    'pain' => (colors.brand, CupertinoIcons.bandage_fill),
    'vitamins' => (colors.warning, CupertinoIcons.sun_max_fill),
    'digestive' => (colors.cyan, CupertinoIcons.flame_fill),
    'diabetes' => (colors.violet, CupertinoIcons.drop_fill),
    'cold' => (colors.coral, CupertinoIcons.thermometer_snowflake),
    'first_aid' => (colors.success, CupertinoIcons.staroflife_fill),
    'heart' => (colors.coral, CupertinoIcons.heart_fill),
    'skin' => (colors.cyan, CupertinoIcons.sparkles),
    _ => (colors.brand, CupertinoIcons.capsule_fill),
  };
}
