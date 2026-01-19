/// Sample for AndroidManifest.xml intent-filter
String androidManifestIntentFilterSample({
  required String domain,
  String? scheme,
}) {
  final List<String> intentFilters = [];

  // Add App Links intent filter if domain is provided
  if (domain.isNotEmpty) {
    intentFilters.add('''
            <!-- App Links -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="http" android:host="$domain" />
                <data android:scheme="https" android:host="$domain" />
            </intent-filter>''');
  }

  // Add Custom Scheme intent filter if scheme is provided
  if (scheme != null && scheme.isNotEmpty) {
    intentFilters.add('''
            <!-- Custom URL Scheme -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="$scheme" />
            </intent-filter>''');
  }

  return intentFilters.join('\n');
}

/// Sample for assetlinks.json
String assetLinksJsonSample({
  required String packageName,
  required String sha256Fingerprint,
}) {
  return '''[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "$packageName",
      "sha256_cert_fingerprints": [
        "$sha256Fingerprint"
      ]
    }
  }
]''';
}

/// Sample for apple-app-site-association
String appleAppSiteAssociationSample({
  required String teamId,
  required String bundleId,
}) {
  return '''{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": ["$teamId.$bundleId"],
        "components": [
          {
            "/": "/*",
            "comment": "Matches all paths"
          }
        ]
      }
    ]
  }
}''';
}

/// Sample for Info.plist CFBundleURLTypes
String infoPlistUrlSchemesSample({required String scheme}) {
  return '''	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$scheme</string>
			</array>
		</dict>
	</array>''';
}

/// Sample for Info.plist FlutterDeepLinkingEnabled setting
/// This prevents iOS from opening Safari after the app when handling universal links
String infoPlistFlutterDeepLinkingSetting() {
  return '''	<key>FlutterDeepLinkingEnabled</key>
	<false/>''';
}

/// Sample for deeplink_handler.dart utility class
String deeplinkHandlerSample() {
  return '''import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeeplinkHandler {
  static final DeeplinkHandler _instance = DeeplinkHandler._internal();
  factory DeeplinkHandler() => _instance;
  DeeplinkHandler._internal();

  final AppLinks _appLinks = AppLinks();
  Function(Uri)? _onLinkReceived;

  /// Initialize deep link handling
  /// Primary method: Uses platformDispatcher.defaultRouteName for initial deep links (iOS workaround)
  /// Secondary: Uses app_links for runtime deep links while app is running
  Future<void> initialize({required Function(Uri) onLinkReceived}) async {
    _onLinkReceived = onLinkReceived;

    // Handle initial link if app was opened from a deep link
    // This will be called after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // PRIMARY METHOD: Get the initial URI from platform dispatcher
        // This is the main solution for iOS with FlutterDeepLinkingEnabled=false
        final initialRoute = WidgetsBinding.instance.platformDispatcher.defaultRouteName;

        if (kDebugMode) {
          print('Platform dispatcher initial route: \$initialRoute');
        }

        if (initialRoute != '/' && initialRoute.isNotEmpty) {
          try {
            final uri = Uri.parse(initialRoute);
            if (kDebugMode) {
              print('✅ Initial deep link detected from platform dispatcher: \$uri');
            }
            _onLinkReceived?.call(uri);
          } catch (parseError) {
            if (kDebugMode) {
              print('❌ Error parsing initial route: \$parseError');
            }
          }
        } else {
          if (kDebugMode) {
            print('ℹ️ No initial deep link detected (normal app launch)');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error getting initial link from platform dispatcher: \$e');
        }
      }
    });

    // Listen for subsequent deep links while app is running
    // This handles new deep links that arrive after the app is already open
    _appLinks.uriLinkStream.listen(
      (uri) {
        if (kDebugMode) {
          print('🔗 Runtime deep link received: \$uri');
        }
        _onLinkReceived?.call(uri);
      },
      onError: (err) {
        if (kDebugMode) {
          print('❌ Error listening to deep links stream: \$err');
        }
      },
    );
  }

  /// Handle deep link navigation
  void handleDeepLink(Uri uri) {
    if (kDebugMode) {
      print('Handling deep link: \$uri');
      print('Scheme: \${uri.scheme}');
      print('Host: \${uri.host}');
      print('Path: \${uri.path}');
      print('Query Parameters: \${uri.queryParameters}');
    }

    // Your custom deep link handling logic here
    // Example: Navigate to specific screens based on path
    _onLinkReceived?.call(uri);
  }
}
''';
}

/// Sample for main.dart integration
String mainDeeplinkIntegrationSample() {
  return '''  // Initialize deep link handler
  DeeplinkHandler().initialize(
    onLinkReceived: (uri) {
      // Handle deep link navigation
      // Example: router.go(uri.path);
      print('Deep link received: \$uri');
    },
  );''';
}
