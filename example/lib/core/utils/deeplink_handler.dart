import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class DeeplinkHandler {
  static final DeeplinkHandler _instance = DeeplinkHandler._internal();
  factory DeeplinkHandler() => _instance;
  DeeplinkHandler._internal();

  final AppLinks _appLinks = AppLinks();
  Function(Uri)? _onLinkReceived;

  /// Initialize deep link handling
  Future<void> initialize({required Function(Uri) onLinkReceived}) async {
    _onLinkReceived = onLinkReceived;

    // Handle initial link if app was opened from a deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        if (kDebugMode) {
          print('Initial deep link: $initialUri');
        }
        _onLinkReceived?.call(initialUri);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting initial link: $e');
      }
    }

    // Listen for subsequent deep links while app is running
    _appLinks.uriLinkStream.listen(
      (uri) {
        if (kDebugMode) {
          print('Received deep link: $uri');
        }
        _onLinkReceived?.call(uri);
      },
      onError: (err) {
        if (kDebugMode) {
          print('Error listening to deep links: $err');
        }
      },
    );
  }

  /// Handle deep link navigation
  void handleDeepLink(Uri uri) {
    if (kDebugMode) {
      print('Handling deep link: $uri');
      print('Scheme: ${uri.scheme}');
      print('Host: ${uri.host}');
      print('Path: ${uri.path}');
      print('Query Parameters: ${uri.queryParameters}');
    }

    // Your custom deep link handling logic here
    // Example: Navigate to specific screens based on path
    _onLinkReceived?.call(uri);
  }
}
