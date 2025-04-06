import 'package:app_features/app_features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toastification/toastification.dart';

BuildContext _context =
    AppFeatures.router.routerDelegate.navigatorKey.currentContext!;

class NotificationUtil {
  static void showLoading() {
    EasyLoading.show();
  }

  static void hideLoading() {
    EasyLoading.dismiss();
  }

  static void showModelSheet(Widget child, {bool isDismissible = false}) {
    AppFeatures.overlay.openModalBottomSheet(
      child,
      isDismissible: isDismissible,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  static void openDialog(
    Widget child, {
    bool isDelay = false,
    bool barrierDismissible = true,
    int? delaySeconds,
  }) {
    showDialog(
        context: _context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          if (isDelay) {
            Future.delayed(Duration(seconds: delaySeconds ?? 5), () {
              AppFeatures.pop();
            });
          }

          return child;
        });
  }

  static void showSuccess(String? message, {Duration? duration}) {
    toastification.show(
      context: _context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(message ?? ''),
      autoCloseDuration: duration ?? const Duration(seconds: 5),
    );
  }

  static void showError(String? message) {
    toastification.show(
      context: _context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(message ?? ''),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
