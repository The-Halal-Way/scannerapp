import 'package:flutter/material.dart';

/// Circular blurred glow blob used as a decorative background element in
/// gradient hero sections.
class GlowBlob extends StatelessWidget {
  const GlowBlob({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0, 1],
        ),
      ),
    );
  }
}
