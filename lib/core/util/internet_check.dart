import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/util/app_access_dialog.dart';

typedef InternetConnectionProbe = Future<bool> Function();

class InternetCheck {
  InternetCheck._();

  static final InternetCheck instance = InternetCheck._();

  InternetConnectionProbe _probe = () => InternetConnection().hasInternetAccess;
  Future<bool>? _activeRecovery;

  Future<bool> get hasConnection async {
    try {
      return await _probe();
    } catch (_) {
      return false;
    }
  }

  Future<bool> ensureConnected(BuildContext context) async {
    if (await hasConnection) return true;
    if (!context.mounted) return false;

    final activeRecovery = _activeRecovery;
    if (activeRecovery != null) return activeRecovery;

    final recovery = _recoverConnection(context);
    _activeRecovery = recovery;
    try {
      return await recovery;
    } finally {
      if (identical(_activeRecovery, recovery)) {
        _activeRecovery = null;
      }
    }
  }

  Future<bool> _recoverConnection(BuildContext context) async {
    while (true) {
      if (!context.mounted) return false;
      final accent = context.appColors.cyan;
      final action = await AppAccessDialog.show(
        context: context,
        data: AppAccessDialogData(
          eyebrow: 'Connection paused',
          title: 'Your workspace is offline',
          message:
              'Reconnect to keep your learning data in sync and continue this request.',
          icon: Icons.wifi_off_rounded,
          primaryLabel: 'Try again',
          secondaryLabel: 'Not now',
          points: const [
            'Your current work stays safely on this screen',
            'The request starts only after internet access returns',
          ],
          accent: accent,
        ),
      );

      if (action != AppAccessDialogAction.primary || !context.mounted) {
        return false;
      }
      if (await hasConnection) return true;
    }
  }

  @visibleForTesting
  void setConnectionProbe(InternetConnectionProbe? probe) {
    _probe = probe ?? (() => InternetConnection().hasInternetAccess);
  }
}
