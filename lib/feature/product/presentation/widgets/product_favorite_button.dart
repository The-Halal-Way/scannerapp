import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class ProductFavoriteButton extends StatelessWidget {
  const ProductFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 30,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? AppIcons.favoriteFilled : AppIcons.favorite,
        size: size * .57,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        fixedSize: Size(size, size),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: colors.surface.withValues(alpha: .94),
        foregroundColor: isFavorite ? colors.coral : colors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * .3),
        ),
      ),
    );
  }
}
