import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

Future<bool> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final colors = context.appColors;
  final wasConfirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.danger.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(AppIcons.delete, color: colors.danger),
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: FilledButton.styleFrom(backgroundColor: colors.danger),
          icon: const Icon(AppIcons.delete),
          label: const Text('Delete'),
        ),
      ],
    ),
  );

  return wasConfirmed ?? false;
}
