import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ScreenUtil policy for layouts authored from the phone design canvas.
///
/// Scaling a 375-point canvas to the full width of a tablet makes spacing,
/// radii, and typography grow independently of the widgets that constrain
/// them. Tablets already provide device-independent logical pixels, so they
/// should use the authored values directly and let responsive layouts decide
/// how to use the additional room.
abstract final class AppScreenScaling {
  static const designSize = Size(375, 812);
  static const tabletBreakpoint = 600.0;

  static bool usePhoneDesignScale() {
    return ScreenUtil().screenWidth < tabletBreakpoint;
  }
}
