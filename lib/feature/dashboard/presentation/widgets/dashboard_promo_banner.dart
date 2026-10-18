import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/dashboard/presentation/widgets/dashboard_promo_slide.dart';

class DashboardPromoBanner extends StatefulWidget {
  const DashboardPromoBanner({super.key, this.onExploreTap, this.onBrowseTap});

  final VoidCallback? onExploreTap;
  final VoidCallback? onBrowseTap;

  @override
  State<DashboardPromoBanner> createState() => _DashboardPromoBannerState();
}

class _DashboardPromoBannerState extends State<DashboardPromoBanner>
    with WidgetsBindingObserver {
  static const _slideCount = 3;
  static const _interval = Duration(seconds: 5);
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleNextPage();
  }

  void _scheduleNextPage() {
    _timer?.cancel();
    _timer = Timer(_interval, () {
      if (!mounted || !_controller.hasClients) return;
      _controller.animateToPage(
        (_currentPage + 1) % _slideCount,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleNextPage();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 134.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: _slideCount,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
              _scheduleNextPage();
            },
            itemBuilder: (context, index) => DashboardPromoSlide(
              index: index,
              onTap: index == 0
                  ? widget.onExploreTap
                  : widget.onBrowseTap ?? widget.onExploreTap,
            ),
          ),
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var index = 0; index < _slideCount; index++)
              AnimatedContainer(
                key: ValueKey('promo-indicator-$index'),
                duration: const Duration(milliseconds: 220),
                width: index == _currentPage ? 18.w : 5.w,
                height: 5.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? colors.brand
                      : colors.strokeStrong,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
