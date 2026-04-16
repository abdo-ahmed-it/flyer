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
            "/": "/*"
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

enum DeeplinkSource {
  /// (Cold Start)
  coldStart,

  /// (Warm Start)
  background,
}

class DeeplinkHandler {
  static final DeeplinkHandler _instance = DeeplinkHandler._internal();

  factory DeeplinkHandler() => _instance;

  DeeplinkHandler._internal();

  final AppLinks _appLinks = AppLinks();
  Function(Uri, DeeplinkSource)? _onLinkReceived;
  Uri? _lastHandledInitialLink;
  bool _initialized = false;

  Future<void> initialize({
    required Function(Uri, DeeplinkSource) onLinkReceived,
  }) async {
    if (_initialized) {
      if (kDebugMode) {
        print('DeeplinkHandler already initialized, skipping...');
      }
      return;
    }

    _initialized = true;
    _onLinkReceived = onLinkReceived;

    // PRIMARY: Check for initial link (Cold Start only)
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _lastHandledInitialLink = initialLink;
        _onLinkReceived?.call(initialLink, DeeplinkSource.coldStart);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting initial link: \$e');
      }
    }

    // SECONDARY: Listen to link stream for background/foreground links
    _appLinks.uriLinkStream.listen((uri) {
      // تجاهل الـ link لو هو نفسه اللي اتعالج كـ initial link
      if (_lastHandledInitialLink != null && uri == _lastHandledInitialLink) {
        _lastHandledInitialLink = null;
        return;
      }
      _onLinkReceived?.call(uri, DeeplinkSource.background);
    });
  }

  /// Handle deep link navigation
  void handleDeepLink(
    Uri uri, {
    DeeplinkSource source = DeeplinkSource.background,
  }) {
    if (kDebugMode) {
      print('Handling deep link: \$uri');
      print('Source: \${source.name}');
      print('Scheme: \${uri.scheme}');
      print('Host: \${uri.host}');
      print('Path: \${uri.path}');
      print('Query Parameters: \${uri.queryParameters}');
    }

    _onLinkReceived?.call(uri, source);
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
