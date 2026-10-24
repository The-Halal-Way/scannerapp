import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/widgets/app_brand.dart';

class AppBrandFooter extends StatelessWidget {
  const AppBrandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 26),
      child: Column(
        children: [
          Divider(color: colors.stroke),
          const SizedBox(height: 18),
          const AppBrand(compact: true),
          const SizedBox(height: 9),
          Text(
            AppBranding.tagline,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
