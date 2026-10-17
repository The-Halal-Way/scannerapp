import 'package:flutter/material.dart';

/// Holds the app's root [GlobalKey<NavigatorState>] so background work (a
/// generation job that keeps running after the screen that started it is
/// gone) can still obtain a [BuildContext] with a live [Overlay] ancestor,
/// instead of relying on a screen's (possibly disposed) context.
class NavigationService {
  NavigationService._();

  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get maybeContext {
    final overlayContext = navigatorKey.currentState?.overlay?.context;
    return overlayContext ?? navigatorKey.currentContext;
  }

  /// A [BuildContext] valid for the lifetime of the app, safe to use for API
  /// calls that outlive the screen which originally triggered them.
  BuildContext get context => maybeContext!;
}
