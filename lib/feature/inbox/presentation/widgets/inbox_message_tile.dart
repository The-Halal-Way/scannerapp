import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/inbox/data/models/inbox_message.dart';

class InboxMessageTile extends StatelessWidget {
  const InboxMessageTile({
    super.key,
    required this.message,
    required this.onTap,
  });

  final InboxMessage message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final accent = categoryColor(colors, message.category);

    return Material(
      color: message.isRead ? colors.surface : colors.surfaceElevated,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: message.isRead
                  ? colors.stroke
                  : accent.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  categoryIcon(message.category),
                  color: accent,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleSmall?.copyWith(
                              fontWeight: message.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!message.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      message.timeLabel,
                      style: text.labelSmall?.copyWith(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color categoryColor(AppThemeColors colors, InboxCategory category) =>
    switch (category) {
      InboxCategory.orders => colors.brand,
      InboxCategory.offers => colors.coral,
      InboxCategory.updates => colors.cyan,
    };

IconData categoryIcon(InboxCategory category) => switch (category) {
  InboxCategory.orders => Icons.local_shipping_outlined,
  InboxCategory.offers => Icons.local_offer_outlined,
  InboxCategory.updates => Icons.auto_awesome_outlined,
};
