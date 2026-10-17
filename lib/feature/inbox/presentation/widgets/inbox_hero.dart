import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class InboxHero extends StatelessWidget {
  const InboxHero({super.key, required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -42,
            right: -28,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STAY IN THE LOOP',
                      style: text.labelSmall?.copyWith(
                        color: colors.cyan,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      unreadCount == 0
                          ? 'You’re all caught up.'
                          : '$unreadCount new ${unreadCount == 1 ? 'update' : 'updates'} for you.',
                      style: text.headlineSmall?.copyWith(
                        color: colors.heroForeground,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Orders, offers and good news. All in one place.',
                      style: text.bodySmall?.copyWith(
                        color: colors.heroForeground.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
