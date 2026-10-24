import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

abstract final class AppBranding {
  static const name = 'IttadiPharma';
  static const tagline = 'Everyday care, thoughtfully delivered.';
}

class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: AppBranding.name,
      image: true,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBrandMark(size: compact ? 34 : 42),
          SizedBox(width: compact ? 9 : 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ittadi',
                style: (compact ? text.titleMedium : text.titleLarge)?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'PHARMA',
                style: text.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: compact ? 8 : 9,
                  height: 1,
                  letterSpacing: compact ? 1.7 : 2.2,
                  color: colors.brand,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({super.key, this.size = 42});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.brand, colors.violet],
        ),
        borderRadius: BorderRadius.circular(size * .32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.add_rounded, size: size * .72, color: Colors.white),
          Positioned(
            top: size * .16,
            right: size * .16,
            child: Container(
              width: size * .12,
              height: size * .12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
