import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/profile/presentation/providers/profile_provider.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
  });

  final ProfileProvider profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(20),
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
                right: -25,
                top: -48,
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.11),
                      width: 23,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    child: Text(
                      profile.initials,
                      style: text.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          profile.pharmacyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.76),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
