import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/profile/presentation/providers/profile_provider.dart';
import 'package:scannerapp/feature/profile/presentation/screens/profile_details_screen.dart';
import 'package:scannerapp/feature/settings/presentation/providers/settings_provider.dart';
import 'package:scannerapp/feature/settings/presentation/widgets/settings_action_tile.dart';
import 'package:scannerapp/feature/settings/presentation/widgets/settings_profile_card.dart';
import 'package:scannerapp/feature/settings/presentation/widgets/settings_toggle_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProfileProvider.instance,
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final profile = context.watch<ProfileProvider>();
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(13, 18, 13, 30),
        children: [
          Text('Settings', style: text.headlineLarge),
          const SizedBox(height: 5),
          Text('Make your Med Club space yours.', style: text.bodyMedium),
          const SizedBox(height: 24),
          SettingsProfileCard(
            profile: profile,
            onTap: () => _openProfile(context),
          ),
          const SizedBox(height: 27),
          _SectionLabel(label: 'ACCOUNT'),
          const SizedBox(height: 11),
          _SettingsGroup(
            children: [
              SettingsActionTile(
                icon: AppIcons.person,
                title: 'Profile details',
                subtitle: 'Contact and pharmacy information',
                onTap: () => _openProfile(context),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _SectionLabel(label: 'PREFERENCES'),
          const SizedBox(height: 11),
          _SettingsGroup(
            children: [
              SettingsToggleTile(
                icon: AppIcons.delivery,
                title: 'Order updates',
                subtitle: 'Know when an order moves',
                value: settings.orderAlerts,
                onChanged: settings.setOrderAlerts,
              ),
              Divider(height: 1, indent: 70, color: colors.stroke),
              SettingsToggleTile(
                icon: AppIcons.offer,
                title: 'Offers & savings',
                subtitle: 'Get news about new deals',
                value: settings.offerAlerts,
                onChanged: settings.setOfferAlerts,
              ),
            ],
          ),
          const SizedBox(height: 25),
          _SectionLabel(label: 'MORE'),
          const SizedBox(height: 11),
          _SettingsGroup(
            children: [
              SettingsActionTile(
                icon: AppIcons.help,
                title: 'Help & support',
                subtitle: 'Quick answers about this app',
                accent: colors.coral,
                onTap: () => _openHelp(context),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              'MED CLUB  ·  WHOLESALE MADE SIMPLE',
              style: text.labelSmall?.copyWith(
                color: colors.textMuted,
                letterSpacing: .15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileDetailsScreen()),
    );
  }

  void _openHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _HelpSheet(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.appColors.textMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: .15,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(children: children),
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = context.appColors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.coral.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(AppIcons.help, color: colors.coral),
            ),
            const SizedBox(height: 16),
            Text('Help & support', style: text.headlineSmall),
            const SizedBox(height: 16),
            Text('Where can I see my orders?', style: text.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Open the Orders tab to check every order and its status.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text('How long are my changes kept?', style: text.titleSmall),
            const SizedBox(height: 4),
            Text(
              'This demo keeps your cart, profile, and preferences for the current app session.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
