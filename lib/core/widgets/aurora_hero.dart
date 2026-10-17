import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/widgets/feature_badge.dart';
import 'package:scannerapp/core/widgets/glow_blob.dart';

/// Shared branded header used by the app's primary workspaces.
///
/// The fixed deep gradient keeps the brand recognizable in either theme,
/// while the surrounding content continues to use semantic theme colors.
class AuroraHero extends StatelessWidget {
  const AuroraHero({
    super.key,
    required this.badgeIcon,
    required this.badgeLabel,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.footer,
    this.compact = false,
  });

  final IconData badgeIcon;
  final String badgeLabel;
  final String title;
  final String subtitle;
  final String? eyebrow;
  final Widget? footer;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.54, 1],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _OrbitPainter())),
            Positioned(
              top: -52.r,
              right: -42.r,
              child: GlowBlob(
                size: 196.r,
                color: colors.cyan.withValues(alpha: 0.24),
              ),
            ),
            Positioned(
              bottom: -74.r,
              left: -42.r,
              child: GlowBlob(
                size: 190.r,
                color: colors.coral.withValues(alpha: 0.2),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  compact ? 10.h : 16.h,
                  20.w,
                  compact ? 18.h : 28.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FeatureBadge(
                              icon: badgeIcon,
                              label: badgeLabel,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _SignalMark(color: colors.cyan),
                      ],
                    ),
                    SizedBox(height: compact ? 10.h : 18.h),
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.cyan,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: compact ? 4.h : 6.h),
                    ],
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        title,
                        style:
                            (compact
                                    ? textTheme.headlineSmall
                                    : textTheme.headlineMedium)
                                ?.copyWith(
                                  color: colors.heroForeground,
                                  fontWeight: FontWeight.w800,
                                  height: 1.12,
                                  letterSpacing: -0.55,
                                ),
                      ),
                    ),
                    SizedBox(height: compact ? 6.h : 9.h),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 610),
                      child: Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.heroForeground.withValues(alpha: 0.72),
                          height: compact ? 1.35 : 1.5,
                        ),
                      ),
                    ),
                    if (footer != null) ...[
                      SizedBox(height: compact ? 14.h : 20.h),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalMark extends StatelessWidget {
  const _SignalMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AI active',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.7), blurRadius: 8),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'LIVE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();

  static const _stars = <Offset>[
    Offset(0.09, 0.24),
    Offset(0.18, 0.52),
    Offset(0.29, 0.14),
    Offset(0.43, 0.72),
    Offset(0.57, 0.22),
    Offset(0.68, 0.61),
    Offset(0.79, 0.15),
    Offset(0.91, 0.48),
    Offset(0.84, 0.82),
    Offset(0.34, 0.9),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final orbitPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.075)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.88, size.height * 0.12),
        width: size.width * 0.58,
        height: size.width * 0.58,
      ),
      orbitPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.04, size.height * 0.94),
        width: size.width * 0.48,
        height: size.width * 0.48,
      ),
      orbitPaint,
    );

    for (var i = 0; i < _stars.length; i++) {
      final point = _stars[i];
      canvas.drawCircle(
        Offset(point.dx * size.width, point.dy * size.height),
        i.isEven ? 1.2 : 0.8,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
