import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

/// A small, asset-free pack illustration used throughout the demo catalog.
class ProductVisual extends StatelessWidget {
  const ProductVisual({
    super.key,
    required this.name,
    required this.category,
    this.compact = false,
  });

  final String name;
  final String category;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accentFor(category, colors);
    final icon = _iconFor(category);

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        final small = compact || side < 130;
        final tiny = side < 105;
        if (side < 72) {
          return _MiniProductVisual(
            side: side,
            accent: accent,
            icon: icon,
            colors: colors,
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(small ? 18 : 28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: isDark ? .23 : .16),
                  colors.surfaceElevated,
                  colors.cyan.withValues(alpha: isDark ? .15 : .08),
                ],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  right: -side * .13,
                  top: -side * .24,
                  child: _Halo(
                    size: side * .8,
                    color: accent.withValues(alpha: .12),
                  ),
                ),
                Positioned(
                  left: -side * .2,
                  bottom: -side * .4,
                  child: _Halo(
                    size: side * .84,
                    color: colors.cyan.withValues(alpha: .1),
                  ),
                ),
                Center(
                  child: Transform.rotate(
                    angle: -.11,
                    child: Container(
                      width: side * (small ? .48 : .43),
                      height: side * (small ? .59 : .70),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(small ? 9 : 15),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: .18),
                            blurRadius: small ? 12 : 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(small ? 9 : 15),
                        child: Column(
                          children: [
                            Container(
                              height: small ? 6 : 12,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [accent, colors.violet],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  small ? (tiny ? 5 : 6) : 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      icon,
                                      color: accent,
                                      size: small ? (tiny ? 14 : 18) : 42,
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: small ? (tiny ? 2 : 3) : 5,
                                      width: side * .18,
                                      decoration: BoxDecoration(
                                        color: accent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: small ? (tiny ? 3 : 4) : 5,
                                    ),
                                    Text(
                                      name,
                                      maxLines: small ? 1 : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: small ? (tiny ? 6 : 7) : 13,
                                        height: 1.1,
                                      ),
                                    ),
                                    if (!small) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'PHARMACY SUPPLY',
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: colors.textMuted,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: small ? 5 : 10,
                              color: accent.withValues(alpha: .2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _accentFor(String category, AppThemeColors colors) {
    final text = category.toLowerCase();
    if (text.contains('vitamin') || text.contains('supplement')) {
      return colors.coral;
    }
    if (text.contains('skin') || text.contains('care')) {
      return colors.violet;
    }
    if (text.contains('device') || text.contains('equipment')) {
      return colors.cyan;
    }
    if (text.contains('first') || text.contains('surgical')) {
      return colors.success;
    }
    return colors.brand;
  }

  static IconData _iconFor(String category) {
    final text = category.toLowerCase();
    if (text.contains('vitamin') || text.contains('supplement')) {
      return Icons.spa_rounded;
    }
    if (text.contains('skin') || text.contains('care')) {
      return Icons.water_drop_rounded;
    }
    if (text.contains('device') || text.contains('equipment')) {
      return Icons.monitor_heart_rounded;
    }
    if (text.contains('first') || text.contains('surgical')) {
      return Icons.medical_services_rounded;
    }
    return Icons.medication_rounded;
  }
}

class _MiniProductVisual extends StatelessWidget {
  const _MiniProductVisual({
    required this.side,
    required this.accent,
    required this.icon,
    required this.colors,
  });

  final double side;
  final Color accent;
  final IconData icon;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent.withValues(alpha: .19), colors.surfaceElevated],
          ),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -.11,
            child: Container(
              width: side * .56,
              height: side * .67,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border(top: BorderSide(color: accent, width: 3)),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: .12),
                    blurRadius: 7,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: side * .27, color: accent),
            ),
          ),
        ),
      ),
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
