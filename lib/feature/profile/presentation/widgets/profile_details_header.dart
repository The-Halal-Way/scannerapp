import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/profile/presentation/providers/profile_provider.dart';

class ProfileDetailsHeader extends StatelessWidget {
  const ProfileDetailsHeader({super.key, required this.profile});

  final ProfileProvider profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            child: Text(
              profile.initials,
              style: text.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            profile.pharmacyName,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              'PHARMACY ACCOUNT',
              style: text.labelSmall?.copyWith(
                color: colors.cyan,
                fontWeight: FontWeight.w800,
                letterSpacing: .15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
