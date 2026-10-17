import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/inbox/data/models/inbox_message.dart';
import 'package:scannerapp/feature/inbox/presentation/providers/inbox_provider.dart';
import 'package:scannerapp/feature/inbox/presentation/widgets/inbox_hero.dart';
import 'package:scannerapp/feature/inbox/presentation/widgets/inbox_message_sheet.dart';
import 'package:scannerapp/feature/inbox/presentation/widgets/inbox_message_tile.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InboxContent();
  }
}

class _InboxContent extends StatelessWidget {
  const _InboxContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final inbox = context.watch<InboxProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Row(
            children: [
              Expanded(child: Text('Inbox', style: text.headlineLarge)),
              if (inbox.unreadCount > 0)
                TextButton.icon(
                  onPressed: inbox.markAllRead,
                  icon: const Icon(Icons.done_all_rounded, size: 18),
                  label: const Text('Read all'),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'A little pulse check on your pharmacy.',
            style: text.bodyMedium,
          ),
          const SizedBox(height: 24),
          InboxHero(unreadCount: inbox.unreadCount),
          const SizedBox(height: 27),
          Text('Your updates', style: text.titleLarge),
          const SizedBox(height: 13),
          _FilterRow(selected: inbox.filter, onSelected: inbox.setFilter),
          const SizedBox(height: 16),
          if (inbox.visibleMessages.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.stroke),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    color: colors.textMuted,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text('Nothing here yet', style: text.titleMedium),
                ],
              ),
            )
          else
            ...inbox.visibleMessages.map(
              (message) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: InboxMessageTile(
                  message: message,
                  onTap: () => _openMessage(context, inbox, message),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openMessage(
    BuildContext context,
    InboxProvider inbox,
    InboxMessage message,
  ) {
    inbox.markRead(message.id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => InboxMessageSheet(message: message),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onSelected});

  final InboxFilter selected;
  final ValueChanged<InboxFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in InboxFilter.values) ...[
            ChoiceChip(
              label: Text(switch (filter) {
                InboxFilter.all => 'All messages',
                InboxFilter.orders => 'Orders',
                InboxFilter.offers => 'Offers',
              }),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
