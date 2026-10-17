import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

enum AppAccessDialogAction { primary, secondary }

class AppAccessDialogMetric {
  const AppAccessDialogMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class AppAccessDialogData {
  const AppAccessDialogData({
    required this.eyebrow,
    required this.title,
    required this.message,
    required this.icon,
    required this.primaryLabel,
    required this.secondaryLabel,
    this.points = const <String>[],
    this.metrics = const <AppAccessDialogMetric>[],
    this.accent,
  });

  final String eyebrow;
  final String title;
  final String message;
  final IconData icon;
  final String primaryLabel;
  final String secondaryLabel;
  final List<String> points;
  final List<AppAccessDialogMetric> metrics;
  final Color? accent;
}

abstract final class AppAccessDialog {
  static Future<AppAccessDialogAction?> show({
    required BuildContext context,
    required AppAccessDialogData data,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<AppAccessDialogAction>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      transitionDuration: const Duration(milliseconds: 340),
      pageBuilder: (_, _, _) => _AccessDialog(data: data),
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _AccessDialog extends StatelessWidget {
  const _AccessDialog({required this.data});

  final AppAccessDialogData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = data.accent ?? colors.brand;
    final width = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: EdgeInsets.all(1.2.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accent.withValues(alpha: 0.95),
                          colors.cyan.withValues(alpha: 0.62),
                          colors.violet.withValues(alpha: 0.86),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.28),
                          blurRadius: 42,
                          spreadRadius: -12,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated.withValues(alpha: 0.97),
                        borderRadius: BorderRadius.circular(29.r),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -42.r,
                            top: -48.r,
                            child: _GlowOrb(
                              size: 138.r,
                              color: accent.withValues(alpha: 0.13),
                            ),
                          ),
                          Positioned(
                            left: -36.r,
                            bottom: 70.h,
                            child: _GlowOrb(
                              size: 100.r,
                              color: colors.cyan.withValues(alpha: 0.09),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              25.h,
                              24.w,
                              22.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _SignalEmblem(icon: data.icon, accent: accent),
                                SizedBox(height: 20.h),
                                Text(
                                  data.eyebrow.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: accent,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.7,
                                      ),
                                ),
                                SizedBox(height: 7.h),
                                Text(
                                  data.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                        height: 1.18,
                                      ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  data.message,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colors.textSecondary,
                                        height: 1.55,
                                      ),
                                ),
                                if (data.metrics.isNotEmpty) ...[
                                  SizedBox(height: 18.h),
                                  _AccessMetrics(
                                    metrics: data.metrics,
                                    accent: accent,
                                  ),
                                ],
                                if (data.points.isNotEmpty) ...[
                                  SizedBox(height: 18.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.07),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.14),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        for (
                                          var index = 0;
                                          index < data.points.length;
                                          index++
                                        ) ...[
                                          _AccessPoint(
                                            text: data.points[index],
                                            accent: accent,
                                          ),
                                          if (index < data.points.length - 1)
                                            SizedBox(height: 9.h),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 22.h),
                                if (width < 340)
                                  _NarrowActions(data: data, accent: accent)
                                else
                                  _WideActions(data: data, accent: accent),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessMetrics extends StatelessWidget {
  const _AccessMetrics({required this.metrics, required this.accent});

  final List<AppAccessDialogMetric> metrics;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final visibleMetrics = metrics.take(2).toList(growable: false);

    return Row(
      children: [
        for (var index = 0; index < visibleMetrics.length; index++) ...[
          if (index > 0) SizedBox(width: 10.w),
          Expanded(
            child: _AccessMetricCard(
              metric: visibleMetrics[index],
              accent: accent,
            ),
          ),
        ],
      ],
    );
  }
}

class _AccessMetricCard extends StatelessWidget {
  const _AccessMetricCard({required this.metric, required this.accent});

  final AppAccessDialogMetric metric;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.12),
            colors.violet.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(metric.icon, size: 17.sp, color: accent),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalEmblem extends StatelessWidget {
  const _SignalEmblem({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: SizedBox.square(
        dimension: 82.r,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: 0.78,
              child: Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.2),
                      colors.violet.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
              ),
            ),
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, colors.violet],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.32),
                    blurRadius: 20,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Icon(icon, color: colors.heroForeground, size: 27.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessPoint extends StatelessWidget {
  const _AccessPoint({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, size: 13.sp, color: accent),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _WideActions extends StatelessWidget {
  const _WideActions({required this.data, required this.accent});

  final AppAccessDialogData data;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                Navigator.pop(context, AppAccessDialogAction.secondary),
            child: Text(data.secondaryLabel),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: FilledButton(
            onPressed: () =>
                Navigator.pop(context, AppAccessDialogAction.primary),
            style: FilledButton.styleFrom(backgroundColor: accent),
            child: Text(data.primaryLabel),
          ),
        ),
      ],
    );
  }
}

class _NarrowActions extends StatelessWidget {
  const _NarrowActions({required this.data, required this.accent});

  final AppAccessDialogData data;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, AppAccessDialogAction.primary),
          style: FilledButton.styleFrom(backgroundColor: accent),
          child: Text(data.primaryLabel),
        ),
        SizedBox(height: 8.h),
        OutlinedButton(
          onPressed: () =>
              Navigator.pop(context, AppAccessDialogAction.secondary),
          child: Text(data.secondaryLabel),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
