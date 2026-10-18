import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

// ── Public surface ────────────────────────────────────────────────────────────

/// Compact music-player–style strip used at the top of both generation
/// screens. Five staggered EQ bars bounce while [isActive]; a shimmer sweeps
/// the track for indeterminate progress, or a fill bar for known progress.
class GenerationPlayerBar extends StatefulWidget {
  const GenerationPlayerBar({
    super.key,
    required this.message,
    this.isActive = false,
    this.isComplete = false,
    this.isFailed = false,
    this.progress,
    this.countLabel,
    this.accentColor,
  });

  final String message;
  final bool isActive;
  final bool isComplete;
  final bool isFailed;

  /// `null` = indeterminate shimmer sweep; `0.0–1.0` = fill bar.
  final double? progress;

  /// Optional label shown right-aligned, e.g. "2 / 4".
  final String? countLabel;

  final Color? accentColor;

  @override
  State<GenerationPlayerBar> createState() => _GenerationPlayerBarState();
}

/// Expanded full-body music-player view for syllabus waiting screens.
/// Shows large EQ bars, a status message, phase step indicators, and a
/// pulsing shimmer track.
class GenerationPlayerBody extends StatefulWidget {
  const GenerationPlayerBody({
    super.key,
    required this.message,
    this.phase = GenerationBodyPhase.processing,
    this.processingHint =
        'Extracting modules, objectives, timeline and priorities…',
  });

  final String message;
  final GenerationBodyPhase phase;
  final String processingHint;

  @override
  State<GenerationPlayerBody> createState() => _GenerationPlayerBodyState();
}

enum GenerationBodyPhase { processing, complete, failed }

// ── GenerationPlayerBar state ─────────────────────────────────────────────────

class _GenerationPlayerBarState extends State<GenerationPlayerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.isActive) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(GenerationPlayerBar old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.isActive && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final color =
        widget.accentColor ??
        (widget.isFailed
            ? colors.danger
            : widget.isComplete
            ? colors.success
            : colors.brand);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _EqBars(
                ctrl: _ctrl,
                color: color,
                isActive: widget.isActive,
                isComplete: widget.isComplete,
                isFailed: widget.isFailed,
                barCount: 5,
                minBarHeight: 4.h,
                maxBarHeight: 18.h,
                barWidth: 3.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  widget.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.countLabel != null) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    widget.countLabel!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 9.h),
          _Track(
            ctrl: _ctrl,
            color: color,
            isActive: widget.isActive,
            isComplete: widget.isComplete,
            isFailed: widget.isFailed,
            progress: widget.progress,
            height: 4.h,
          ),
        ],
      ),
    );
  }
}

// ── GenerationPlayerBody state ────────────────────────────────────────────────

class _GenerationPlayerBodyState extends State<GenerationPlayerBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.phase == GenerationBodyPhase.processing) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(GenerationPlayerBody old) {
    super.didUpdateWidget(old);
    final active = widget.phase == GenerationBodyPhase.processing;
    if (active && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!active && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final isProcessing = widget.phase == GenerationBodyPhase.processing;
    final isFailed = widget.phase == GenerationBodyPhase.failed;
    final isComplete = widget.phase == GenerationBodyPhase.complete;

    final Color color = isFailed
        ? colors.danger
        : isComplete
        ? colors.success
        : colors.brand;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Large EQ bars or state icon
            if (isFailed)
              Icon(AppIcons.error, size: 40.sp, color: colors.danger)
            else if (isComplete)
              Icon(AppIcons.checked, size: 40.sp, color: colors.success)
            else
              _EqBars(
                ctrl: _ctrl,
                color: color,
                isActive: isProcessing,
                isComplete: false,
                isFailed: false,
                barCount: 7,
                minBarHeight: 6.h,
                maxBarHeight: 40.h,
                barWidth: 5.w,
                gapWidth: 4.w,
              ),
            SizedBox(height: 24.h),
            // Status message
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            if (isProcessing) ...[
              SizedBox(height: 6.h),
              Text(
                widget.processingHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
            SizedBox(height: 28.h),
            // Shimmer track
            _Track(
              ctrl: _ctrl,
              color: color,
              isActive: isProcessing,
              isComplete: isComplete,
              isFailed: isFailed,
              progress: null,
              height: 4.h,
            ),
            SizedBox(height: 16.h),
            // Phase step indicators
            if (!isFailed) _PhaseSteps(color: color, phase: widget.phase),
          ],
        ),
      ),
    );
  }
}

// ── Shared private atoms ──────────────────────────────────────────────────────

/// Five (or [barCount]) staggered equalizer bars that bounce when [isActive].
class _EqBars extends StatelessWidget {
  const _EqBars({
    required this.ctrl,
    required this.color,
    required this.isActive,
    required this.isComplete,
    required this.isFailed,
    required this.barCount,
    required this.minBarHeight,
    required this.maxBarHeight,
    required this.barWidth,
    this.gapWidth,
  });

  final AnimationController ctrl;
  final Color color;
  final bool isActive;
  final bool isComplete;
  final bool isFailed;
  final int barCount;
  final double minBarHeight;
  final double maxBarHeight;
  final double barWidth;
  final double? gapWidth;

  @override
  Widget build(BuildContext context) {
    if (isFailed) {
      return Icon(AppIcons.error, size: maxBarHeight + 2, color: color);
    }
    if (isComplete) {
      return Icon(AppIcons.checked, size: maxBarHeight + 2, color: color);
    }

    final gap = gapWidth ?? 2.w;
    // Each bar has a different phase offset so they move out of sync.
    final phases = List.generate(barCount, (i) => i / barCount);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(barCount, (i) {
            final double t = isActive ? ctrl.value : 0.0;
            final double normalized = (sin((t + phases[i]) * 2 * pi) + 1) / 2;
            final double height =
                minBarHeight + normalized * (maxBarHeight - minBarHeight);
            return Padding(
              padding: EdgeInsets.only(right: i < barCount - 1 ? gap : 0),
              child: Container(
                width: barWidth,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(barWidth / 2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Animated progress track: shimmer sweep when indeterminate + active,
/// fill bar when progress is given, flat bar otherwise.
class _Track extends StatelessWidget {
  const _Track({
    required this.ctrl,
    required this.color,
    required this.isActive,
    required this.isComplete,
    required this.isFailed,
    required this.progress,
    required this.height,
  });

  final AnimationController ctrl;
  final Color color;
  final bool isActive;
  final bool isComplete;
  final bool isFailed;
  final double? progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (isFailed) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: Container(height: height, color: color.withValues(alpha: 0.25)),
      );
    }

    if (isComplete) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.success, colors.cyan, colors.brand],
            ),
          ),
        ),
      );
    }

    if (progress != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: LinearProgressIndicator(
          value: progress!.clamp(0.0, 1.0),
          minHeight: height,
          backgroundColor: color.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    // Indeterminate: shimmer sweeps left-to-right
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Container(color: color.withValues(alpha: 0.15)),
                Align(
                  alignment: Alignment(ctrl.value * 2 - 1, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.38,
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0),
                            color.withValues(alpha: 0.9),
                            color.withValues(alpha: 0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Horizontal "Upload → Analyze → Done" step indicator for the syllabus body.
class _PhaseSteps extends StatelessWidget {
  const _PhaseSteps({required this.color, required this.phase});

  final Color color;
  final GenerationBodyPhase phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    const steps = ['Upload', 'Analyze', 'Done'];
    final activeIndex = phase == GenerationBodyPhase.processing
        ? 1
        : phase == GenerationBodyPhase.complete
        ? 2
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Container(
              width: 28.w,
              height: 1.h,
              color: i <= activeIndex ? color : colors.strokeStrong,
            ),
          _StepDot(
            label: steps[i],
            isActive: i == activeIndex,
            isDone: i < activeIndex,
            color: color,
            theme: theme,
            inactiveColor: colors.strokeStrong,
            mutedColor: colors.textMuted,
          ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isActive,
    required this.isDone,
    required this.color,
    required this.theme,
    required this.inactiveColor,
    required this.mutedColor,
  });

  final String label;
  final bool isActive;
  final bool isDone;
  final Color color;
  final ThemeData theme;
  final Color inactiveColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive ? color : inactiveColor,
            border: isActive
                ? Border.all(color: color.withValues(alpha: 0.3), width: 3.r)
                : null,
          ),
          child: isDone
              ? Icon(AppIcons.check, size: 7.sp, color: Colors.white)
              : null,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isActive ? color : mutedColor,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }
}
