String appNotificationsSample() {
  return '''
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling background message: \${message.messageId}');
  if (AppNotifications._backgroundMessageCallback != null) {
    AppNotifications._backgroundMessageCallback!(message);
  }
}

class AppNotifications {
  AppNotifications._instance();

  static AppNotifications? _service;
  static ValueChanged<RemoteMessage>? _backgroundMessageCallback;

  static AppNotifications instance() {
    if (_service != null) {
      return _service!;
    }
    _service = AppNotifications._instance();
    return _service!;
  }

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  Future<void> init({
    ValueChanged<RemoteMessage>? onOpenedApp,
    ValueChanged<RemoteMessage>? onReceived,
    ValueChanged<RemoteMessage>? onBackgroundMessage,
  }) async {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();

    await sendRequest();

    _onMessageSubscription = FirebaseMessaging.onMessage.listen((event) {
      if (onReceived != null) {
        onReceived(event);
      }
    });

    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('event : \$event');
      if (onOpenedApp != null) {
        onOpenedApp(event);
      }
    });

    if (onBackgroundMessage != null) {
      _backgroundMessageCallback = onBackgroundMessage;
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    }

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && onOpenedApp != null) {
      onOpenedApp(initialMessage);
    }
  }

  Future<void> getToken(ValueChanged<String?> token) async {
    try {
      token(await FirebaseMessaging.instance.getToken());
    } catch (e) {
      debugPrint('Error getting FCM token: \$e');
    }
  }

  Future<AppNotifications> sendRequest() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }
    return this;
  }

  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
  }
}
''';
}
