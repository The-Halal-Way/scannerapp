// ignore_for_file: use_build_context_synchronously
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';

class MyDialog {
  void showSuccessToast({
    required String msg,
    String title = "Successful",
    required BuildContext context,
  }) {
    final colors = context.appColors;
    ElegantNotification.success(
      isDismissable: false,
      position: Alignment.topCenter,
      toastDuration: const Duration(milliseconds: 2300),
      width: _notificationWidth(context),
      background: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.stroke),
      verticalDividerColor: colors.stroke,
      progressIndicatorBackground: colors.surfaceMuted,
      animation: AnimationType.fromTop,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        msg,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
      ),
      shadow: BoxShadow(
        color: Colors.green.withValues(alpha: 0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4),
      ),
    ).show(context);
  }

  void showInfoToast({
    required String msg,
    String title = 'Heads up',
    required BuildContext context,
  }) {
    final colors = context.appColors;
    ElegantNotification.info(
      isDismissable: false,
      position: Alignment.topCenter,
      toastDuration: const Duration(milliseconds: 2300),
      width: _notificationWidth(context),
      background: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.stroke),
      verticalDividerColor: colors.stroke,
      progressIndicatorBackground: colors.surfaceMuted,
      animation: AnimationType.fromTop,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        msg,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
      ),
      shadow: BoxShadow(
        color: const Color(0xFF01204E).withValues(alpha: 0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4),
      ),
    ).show(context);
  }

  void showFailedToast({
    required String msg,
    String title = "Failed",
    required BuildContext context,
  }) {
    final colors = context.appColors;
    ElegantNotification.error(
      stackedOptions: StackedOptions(
        key: 'topRight',
        type: StackedType.below,
        itemOffset: const Offset(0, 5),
      ),
      position: Alignment.topCenter,
      toastDuration: const Duration(milliseconds: 2300),
      width: _notificationWidth(context),
      background: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.stroke),
      verticalDividerColor: colors.stroke,
      progressIndicatorBackground: colors.surfaceMuted,
      animation: AnimationType.fromTop,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        msg,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
      ),
    ).show(context);
  }

  double _notificationWidth(BuildContext context) {
    return (MediaQuery.sizeOf(context).width - 32).clamp(260, 350).toDouble();
  }
}
