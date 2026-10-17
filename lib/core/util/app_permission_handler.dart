import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/util/app_access_dialog.dart';

class PermissionPrompt {
  const PermissionPrompt({
    required this.name,
    required this.message,
    required this.points,
    this.icon = Icons.shield_outlined,
  });

  final String name;
  final String message;
  final List<String> points;
  final IconData icon;
}

class AppPermissionHandler {
  AppPermissionHandler._();

  static final AppPermissionHandler instance = AppPermissionHandler._();

  Future<bool> request({
    required BuildContext context,
    required Permission permission,
    List<Permission> fallbackPermissions = const <Permission>[],
    PermissionPrompt? prompt,
  }) async {
    final permissions = <Permission>[permission, ...fallbackPermissions];
    final statuses = await _statuses(permissions);

    if (statuses.any(_isUsable)) return true;
    if (!context.mounted) return false;

    final details = prompt ?? _promptFor(permission);
    if (statuses.every(_requiresSettings)) {
      return _offerSettings(context: context, prompt: details);
    }

    final action = await AppAccessDialog.show(
      context: context,
      data: AppAccessDialogData(
        eyebrow: '${details.name} permission',
        title: 'A quick permission check',
        message: details.message,
        icon: details.icon,
        primaryLabel: 'Continue',
        secondaryLabel: 'Not now',
        points: details.points,
        accent: context.appColors.violet,
      ),
    );
    if (action != AppAccessDialogAction.primary || !context.mounted) {
      return false;
    }

    for (final item in permissions) {
      final current = await item.status;
      if (_isUsable(current)) return true;
      if (_requiresSettings(current)) {
        continue;
      }

      final result = await item.request();
      if (_isUsable(result)) return true;
    }

    if (!context.mounted) return false;
    return _offerSettings(context: context, prompt: details);
  }

  Future<List<PermissionStatus>> _statuses(List<Permission> permissions) async {
    return Future.wait(permissions.map((permission) => permission.status));
  }

  bool _isUsable(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  bool _requiresSettings(PermissionStatus status) {
    return status.isPermanentlyDenied || status.isRestricted;
  }

  Future<bool> _offerSettings({
    required BuildContext context,
    required PermissionPrompt prompt,
  }) async {
    final action = await AppAccessDialog.show(
      context: context,
      data: AppAccessDialogData(
        eyebrow: '${prompt.name} blocked',
        title: 'Turn access on in Settings',
        message:
            'The app cannot open the system permission prompt again. You can enable ${prompt.name.toLowerCase()} access from the app settings.',
        icon: Icons.settings_suggest_outlined,
        primaryLabel: 'Open settings',
        secondaryLabel: 'Maybe later',
        points: const [
          'You stay in control and can change access at any time',
          'Return here after enabling the permission',
        ],
        accent: context.appColors.violet,
      ),
    );

    if (action == AppAccessDialogAction.primary) {
      await openAppSettings();
    }
    return false;
  }

  PermissionPrompt _promptFor(Permission permission) {
    if (permission == Permission.photos ||
        permission == Permission.photosAddOnly) {
      return const PermissionPrompt(
        name: 'Photos',
        message:
            'Choose an image from your library to personalize your profile.',
        points: [
          'Only the photo you choose is used',
          'Your library is never uploaded in the background',
        ],
        icon: Icons.photo_library_outlined,
      );
    }
    if (permission == Permission.camera) {
      return const PermissionPrompt(
        name: 'Camera',
        message:
            'Camera access lets you capture an image without leaving the app.',
        points: [
          'The camera opens only when you request it',
          'Captured media remains under your control',
        ],
        icon: Icons.camera_alt_outlined,
      );
    }
    if (permission == Permission.microphone) {
      return const PermissionPrompt(
        name: 'Microphone',
        message:
            'Microphone access is needed to record audio for this feature.',
        points: [
          'Recording starts only after your action',
          'You can revoke access from Settings at any time',
        ],
        icon: Icons.mic_none_rounded,
      );
    }
    if (permission == Permission.location ||
        permission == Permission.locationWhenInUse ||
        permission == Permission.locationAlways) {
      return const PermissionPrompt(
        name: 'Location',
        message: 'Location access is needed to complete this action.',
        points: [
          'Location is requested only for this feature',
          'You can change access from Settings at any time',
        ],
        icon: Icons.location_on_outlined,
      );
    }
    if (permission == Permission.notification) {
      return const PermissionPrompt(
        name: 'Notifications',
        message: 'Enable notifications to receive timely workspace updates.',
        points: [
          'Only useful learning updates are sent',
          'Notification access can be changed at any time',
        ],
        icon: Icons.notifications_none_rounded,
      );
    }
    if (permission == Permission.storage) {
      return const PermissionPrompt(
        name: 'Storage',
        message: 'Storage access is needed to select this file.',
        points: [
          'Only the file you choose is used',
          'Other files remain private',
        ],
        icon: Icons.folder_open_outlined,
      );
    }
    if (permission == Permission.contacts) {
      return const PermissionPrompt(
        name: 'Contacts',
        message: 'Contacts access is needed to complete this action.',
        points: [
          'Contacts are accessed only for this feature',
          'You can revoke access at any time',
        ],
        icon: Icons.contacts_outlined,
      );
    }

    return const PermissionPrompt(
      name: 'Device',
      message: 'This feature needs permission before it can continue.',
      points: [
        'Access is used only for the feature you selected',
        'You can change the permission from Settings at any time',
      ],
    );
  }
}
