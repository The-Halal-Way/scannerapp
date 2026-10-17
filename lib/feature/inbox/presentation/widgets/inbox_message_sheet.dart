import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/inbox/data/models/inbox_message.dart';
import 'package:scannerapp/feature/inbox/presentation/widgets/inbox_message_tile.dart';

class InboxMessageSheet extends StatelessWidget {
  const InboxMessageSheet({super.key, required this.message});

  final InboxMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final accent = categoryColor(colors, message.category);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                categoryIcon(message.category),
                color: accent,
                size: 26,
              ),
            ),
            const SizedBox(height: 18),
            Text(message.title, style: text.headlineSmall),
            const SizedBox(height: 7),
            Text(message.timeLabel, style: text.bodySmall),
            const SizedBox(height: 18),
            Text(
              message.body,
              style: text.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
