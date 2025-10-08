# 🔗 Deep Linking Guide for Flutter

## Overview

Flyer CLI provides a powerful deep linking generator that automatically creates a complete deep link handling system for your Flutter app. It generates everything you need to handle deep links, including route parsing, navigation, and configuration files.

## Table of Contents

- [What is Deep Linking?](#what-is-deep-linking)
- [Quick Start](#quick-start)
- [Command Usage](#command-usage)
- [Generated Structure](#generated-structure)
- [Configuration](#configuration)
- [Testing Deep Links](#testing-deep-links)
- [Platform Setup](#platform-setup)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

---

## What is Deep Linking?

Deep linking allows users to open specific screens in your app directly from:
- **URLs in browsers** (e.g., `https://yourapp.com/product/123`)
- **Other apps** (e.g., clicking a link in an email)
- **Push notifications**
- **QR codes**
- **Marketing campaigns**

### Deep Link vs Universal Link

| Feature | Deep Link | Universal Link |
|---------|-----------|----------------|
| Protocol | Custom (e.g., `myapp://`) | HTTPS (e.g., `https://`) |
| Fallback | Opens browser if app not installed | Opens website if app not installed |
| Setup | Simple | Requires domain verification |
| User Experience | Shows "Open with..." dialog | Seamless, no dialog |
| Best for | Testing, internal use | Production, better UX |

---

## Quick Start

### 1. Generate Deep Link System

```bash
cd your-flutter-project
flyer deeplink
```

This will prompt you for:
1. **Scheme**: Your app's custom URL scheme (e.g., `myapp`)
2. **Host**: Your domain or app identifier (e.g., `example.com`)

### 2. What Gets Generated

```
lib/
└── functions/
    └── deeplink/
        ├── deeplink_handler.dart      # Main deep link handler
        ├── deeplink_routes.dart       # Route parsing logic
        └── deeplink_config.dart       # Configuration constants

android/
└── app/
    └── src/
        └── main/
            └── AndroidManifest.xml    # Updated with intent filters

ios/
└── Runner/
    └── Info.plist                     # Updated with URL types
```

### 3. Initialize in Your App

The generator automatically adds the necessary code, but here's what happens:

**In `lib/main.dart`:**
```dart
import 'package:flyer/functions/deeplink/deeplink_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkHandler.initialize(); // Automatically added
  runApp(MyApp());
}
```

### 4. Test It

**Android:**
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "myapp://example.com/product/123"
```

**iOS:**
```bash
xcrun simctl openurl booted "myapp://example.com/product/123"
```

---

## Command Usage

### Basic Command

```bash
flyer deeplink
```

This will prompt you interactively for scheme and host.

### With Options (Coming Soon)

```bash
# Specify scheme and host directly
flyer deeplink --scheme myapp --host example.com

# Enable universal links (HTTPS)
flyer deeplink --scheme myapp --host example.com --universal

# Skip iOS configuration
flyer deeplink --scheme myapp --host example.com --no-ios

# Skip Android configuration
flyer deeplink --scheme myapp --host example.com --no-android
```

---

## Generated Structure

### 1. DeepLinkConfig (`lib/functions/deeplink/deeplink_config.dart`)

Holds your deep link configuration constants:

```dart
class DeepLinkConfig {
  // Your custom URL scheme (e.g., "myapp")
  static const String scheme = 'myapp';

  // Your domain/host (e.g., "example.com")
  static const String host = 'example.com';

  // Full deep link prefix
  static String get prefix => '$scheme://$host';

  // Example URLs:
  // myapp://example.com/
  // myapp://example.com/product/123
  // myapp://example.com/user/profile?id=456
}
```

### 2. DeepLinkRoutes (`lib/functions/deeplink/deeplink_routes.dart`)

Parses deep link URLs and extracts route information:

```dart
class DeepLinkRoutes {
  // Parse a deep link URL
  static DeepLinkData? parse(String url) {
    final uri = Uri.parse(url);

    // Validate scheme and host
    if (uri.scheme != DeepLinkConfig.scheme ||
        uri.host != DeepLinkConfig.host) {
      return null;
    }

    // Extract path and parameters
    return DeepLinkData(
      path: uri.path,
      queryParameters: uri.queryParameters,
    );
  }
}

class DeepLinkData {
  final String path;
  final Map<String, String> queryParameters;

  DeepLinkData({required this.path, required this.queryParameters});
}
```

**Usage Example:**
```dart
final data = DeepLinkRoutes.parse('myapp://example.com/product/123?ref=email');
print(data.path); // "/product/123"
print(data.queryParameters['ref']); // "email"
```

### 3. DeepLinkHandler (`lib/functions/deeplink/deeplink_handler.dart`)

Main handler that listens for deep links and navigates:

```dart
class DeepLinkHandler {
  static StreamSubscription? _subscription;

  // Initialize deep link listener
  static void initialize() {
    // Handle deep link when app is terminated
    _handleInitialLink();

    // Handle deep links when app is running
    _handleIncomingLinks();
  }

  // Handle the link that opened the app
  static Future<void> _handleInitialLink() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      print('Error handling initial link: $e');
    }
  }

  // Listen for links while app is running
  static void _handleIncomingLinks() {
    _subscription = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      },
      onError: (err) {
        print('Error handling deep link: $err');
      },
    );
  }

  // Process and navigate based on deep link
  static void _handleDeepLink(String url) {
    final deepLinkData = DeepLinkRoutes.parse(url);

    if (deepLinkData != null) {
      _navigate(deepLinkData);
    }
  }

  // Navigate to the appropriate screen
  static void _navigate(DeepLinkData data) {
    // TODO: Implement your navigation logic
    // Example:
    // if (data.path.startsWith('/product/')) {
    //   final productId = data.path.split('/').last;
    //   navigatorKey.currentState?.pushNamed('/product', arguments: productId);
    // }
  }

  // Clean up subscription
  static void dispose() {
    _subscription?.cancel();
  }
}
```

---

## Configuration

### Customize Route Handling

Edit `lib/functions/deeplink/deeplink_handler.dart` to add your navigation logic:

```dart
static void _navigate(DeepLinkData data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  // Home route
  if (data.path == '/' || data.path.isEmpty) {
    context.go('/');
    return;
  }

  // Product detail: myapp://example.com/product/123
  if (data.path.startsWith('/product/')) {
    final productId = data.path.split('/').last;
    context.go('/product/$productId');
    return;
  }

  // User profile: myapp://example.com/user/profile?id=456
  if (data.path == '/user/profile') {
    final userId = data.queryParameters['id'];
    context.go('/profile/$userId');
    return;
  }

  // Category with filters: myapp://example.com/category?name=electronics&sort=price
  if (data.path.startsWith('/category')) {
    final category = data.queryParameters['name'];
    final sort = data.queryParameters['sort'];
    context.go('/category?name=$category&sort=$sort');
    return;
  }

  // Default: go to home
  context.go('/');
}
```

### Using with GoRouter

If you're using GoRouter (recommended with Flyer), you can use the `go()` method:

```dart
import 'package:go_router/go_router.dart';

static void _navigate(DeepLinkData data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  // GoRouter automatically handles the routing
  context.go(data.path, extra: data.queryParameters);
}
```

### Using with Navigator

If you're using traditional Navigator:

```dart
static void _navigate(DeepLinkData data) {
  if (data.path.startsWith('/product/')) {
    final productId = data.path.split('/').last;
    navigatorKey.currentState?.pushNamed(
      '/product',
      arguments: {'id': productId, ...data.queryParameters},
    );
  }
}
```

---

## Testing Deep Links

### 1. Testing on Android

**Using ADB:**
```bash
# Basic deep link
adb shell am start -W -a android.intent.action.VIEW \
  -d "myapp://example.com/"

# Product page
adb shell am start -W -a android.intent.action.VIEW \
  -d "myapp://example.com/product/123"

# With query parameters
adb shell am start -W -a android.intent.action.VIEW \
  -d "myapp://example.com/search?q=flutter&sort=popular"
```

**Using Android Studio:**
1. Run your app
2. Open Terminal in Android Studio
3. Run the ADB command above

### 2. Testing on iOS

**Using Simulator:**
```bash
# Get the device ID
xcrun simctl list devices | grep Booted

# Open deep link
xcrun simctl openurl booted "myapp://example.com/product/123"
```

**Using Safari on Simulator:**
1. Run your app on simulator
2. Open Safari on the simulator
3. Type your deep link in the address bar: `myapp://example.com/product/123`
4. Press Go

### 3. Testing on Real Devices

**Create a Test HTML Page:**

Create `test_deeplinks.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Deep Link Test Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        .link-button {
            display: block;
            padding: 15px;
            margin: 10px 0;
            background: #007AFF;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>Test Deep Links</h1>
    <a href="myapp://example.com/" class="link-button">Open Home</a>
    <a href="myapp://example.com/product/123" class="link-button">Open Product 123</a>
    <a href="myapp://example.com/user/profile?id=456" class="link-button">Open Profile</a>
    <a href="myapp://example.com/search?q=flutter" class="link-button">Search for Flutter</a>
</body>
</html>
```

**Host it:**
- Upload to a web server, or
- Use GitHub Pages, or
- Use a local server: `python3 -m http.server 8000`

**Test:**
1. Open the page on your device's browser
2. Tap any link
3. Your app should open

### 4. Testing with QR Codes

Generate QR codes for your deep links:

```bash
# Using online tool: https://www.qr-code-generator.com/
# Or use a QR code package in your test app
```

---

## Platform Setup

### Android Setup

The generator automatically updates `AndroidManifest.xml`, but here's what it adds:

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<activity
    android:name=".MainActivity"
    ...>

    <!-- Existing intent filters... -->

    <!-- Deep Link Intent Filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />

        <!-- Your custom scheme -->
        <data
            android:scheme="myapp"
            android:host="example.com" />
    </intent-filter>
</activity>
```

**For Universal Links (HTTPS):**

Add an additional intent filter:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <!-- HTTPS scheme -->
    <data
        android:scheme="https"
        android:host="example.com" />
</intent-filter>
```

And create `assetlinks.json` (see Universal Links section).

### iOS Setup

The generator automatically updates `Info.plist`, but here's what it adds:

**File:** `ios/Runner/Info.plist`

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.example.myapp</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myapp</string>
        </array>
    </dict>
</array>
```

**For Universal Links (HTTPS):**

Add Associated Domains:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:example.com</string>
</array>
```

And create `apple-app-site-association` file (see Universal Links section).

---

## Examples

### Example 1: E-commerce App

**Deep Link Structure:**
```
myapp://shop.com/product/123           → Product detail page
myapp://shop.com/category/electronics  → Category listing
myapp://shop.com/cart                  → Shopping cart
myapp://shop.com/checkout              → Checkout page
myapp://shop.com/order/456             → Order tracking
```

**Implementation:**
```dart
static void _navigate(DeepLinkData data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  if (data.path.startsWith('/product/')) {
    final productId = data.path.split('/').last;
    context.go('/product/$productId');
  } else if (data.path.startsWith('/category/')) {
    final category = data.path.split('/').last;
    context.go('/category/$category');
  } else if (data.path == '/cart') {
    context.go('/cart');
  } else if (data.path == '/checkout') {
    context.go('/checkout');
  } else if (data.path.startsWith('/order/')) {
    final orderId = data.path.split('/').last;
    context.go('/order/$orderId');
  } else {
    context.go('/');
  }
}
```

### Example 2: Social Media App

**Deep Link Structure:**
```
myapp://social.app/profile/john_doe    → User profile
myapp://social.app/post/789            → Specific post
myapp://social.app/chat/alice          → Chat with user
myapp://social.app/notifications       → Notifications
```

**Implementation:**
```dart
static void _navigate(DeepLinkData data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  if (data.path.startsWith('/profile/')) {
    final username = data.path.split('/').last;
    context.go('/profile/$username');
  } else if (data.path.startsWith('/post/')) {
    final postId = data.path.split('/').last;
    context.go('/post/$postId');
  } else if (data.path.startsWith('/chat/')) {
    final userId = data.path.split('/').last;
    context.go('/chat/$userId');
  } else if (data.path == '/notifications') {
    context.go('/notifications');
  } else {
    context.go('/feed');
  }
}
```

### Example 3: With Analytics Tracking

Track which deep links users are using:

```dart
static void _handleDeepLink(String url) {
  final deepLinkData = DeepLinkRoutes.parse(url);

  if (deepLinkData != null) {
    // Track deep link usage
    Analytics.logEvent(
      'deep_link_opened',
      parameters: {
        'path': deepLinkData.path,
        'source': deepLinkData.queryParameters['ref'] ?? 'unknown',
      },
    );

    _navigate(deepLinkData);
  } else {
    Analytics.logEvent('invalid_deep_link', parameters: {'url': url});
  }
}
```

### Example 4: With Authentication Check

Redirect to login if user is not authenticated:

```dart
static void _navigate(DeepLinkData data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  // Check if route requires authentication
  final protectedRoutes = ['/profile', '/checkout', '/orders'];
  final requiresAuth = protectedRoutes.any((route) => data.path.startsWith(route));

  if (requiresAuth && !AuthService.isLoggedIn) {
    // Save the intended destination
    SharedPreferences.setString('intended_route', data.path);

    // Go to login
    context.go('/login');
    return;
  }

  // Navigate normally
  context.go(data.path);
}
```

---

## Universal Links (HTTPS Deep Links)

Universal Links (iOS) and App Links (Android) allow your app to handle HTTPS URLs without showing the "Open with..." dialog.

### Setup Steps

#### 1. Android App Links

**Create `assetlinks.json`:**
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.myapp",
    "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
  }
}]
```

**Get SHA256 fingerprint:**
```bash
# For debug key
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release key
keytool -list -v -keystore /path/to/your-release-key.jks -alias your-key-alias
```

**Host the file:**
Upload `assetlinks.json` to:
```
https://example.com/.well-known/assetlinks.json
```

**Update AndroidManifest.xml:**
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="example.com" />
</intent-filter>
```

#### 2. iOS Universal Links

**Create `apple-app-site-association`:**
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.example.myapp",
        "paths": ["*"]
      }
    ]
  }
}
```

**Get Team ID:**
- Log in to Apple Developer Portal
- Go to Membership → Team ID

**Host the file:**
Upload to:
```
https://example.com/.well-known/apple-app-site-association
```

**Important:** File must:
- Have NO file extension
- Be served with `Content-Type: application/json`
- Be accessible via HTTPS

**Update Info.plist:**
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:example.com</string>
</array>
```

**Enable Associated Domains in Xcode:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Associated Domains"
6. Add domain: `applinks:example.com`

### Testing Universal Links

**Android:**
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://example.com/product/123"
```

**iOS:**
```bash
xcrun simctl openurl booted "https://example.com/product/123"
```

**Verify Setup:**
- Android: https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://example.com
- iOS: Use Apple's App Search API Validation Tool

---

## Troubleshooting

### Deep Link Not Opening App

**Check:**
1. Verify scheme and host match in all files
2. Rebuild app after changing manifest/Info.plist
3. Test with correct URL format

**Android:**
```bash
# Check if intent filter is registered
adb shell dumpsys package com.example.myapp | grep -A 20 "android.intent.action.VIEW"
```

**iOS:**
```bash
# Check URL schemes
xcrun simctl launch booted com.example.myapp --console | grep "URL"
```

### App Opens But Doesn't Navigate

**Debug:**
Add logging to DeepLinkHandler:

```dart
static void _handleDeepLink(String url) {
  print('🔗 Received deep link: $url');

  final deepLinkData = DeepLinkRoutes.parse(url);

  if (deepLinkData == null) {
    print('❌ Failed to parse deep link');
    return;
  }

  print('✅ Parsed - Path: ${deepLinkData.path}');
  print('✅ Query params: ${deepLinkData.queryParameters}');

  _navigate(deepLinkData);
}

static void _navigate(DeepLinkData data) {
  print('🧭 Navigating to: ${data.path}');
  // Your navigation logic...
}
```

### Universal Links Not Working

**Android:**
1. Verify `assetlinks.json` is accessible
2. Check package name and SHA256 match
3. Verify `android:autoVerify="true"` is set
4. Test with: `https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://example.com`

**iOS:**
1. Verify `apple-app-site-association` file is accessible
2. Check Team ID and Bundle ID match
3. Verify Associated Domains capability is enabled
4. Try clearing app and reinstalling

### Links Open in Browser Instead of App

This usually happens with Universal Links:

**Android:**
- User might have chosen "Always open in browser"
- Clear defaults: Settings → Apps → Your App → Set as default → Clear defaults

**iOS:**
- Links opened in Safari won't trigger Universal Links (by design)
- Links must come from different apps (Messages, Mail, etc.)
- Try long-pressing link → select "Open in App"

---

## Best Practices

### 1. Consistent URL Structure

Use a clear, RESTful URL structure:
```
✅ Good:
myapp://example.com/product/123
myapp://example.com/user/profile
myapp://example.com/category/electronics

❌ Bad:
myapp://example.com/p?id=123
myapp://example.com/usr
myapp://example.com/cat_electronics
```

### 2. Handle All Cases

Always provide fallbacks:
```dart
static void _navigate(DeepLinkData data) {
  try {
    // Attempt navigation
    context.go(data.path);
  } catch (e) {
    // Fallback to home if route doesn't exist
    print('Navigation failed: $e');
    context.go('/');
  }
}
```

### 3. Use Query Parameters for Optional Data

```
myapp://example.com/search?q=flutter&sort=popular&filter=recent
```

### 4. Validate Input

Always validate data from deep links:
```dart
if (data.path.startsWith('/product/')) {
  final productId = data.path.split('/').last;

  // Validate product ID
  if (int.tryParse(productId) == null) {
    print('Invalid product ID');
    context.go('/');
    return;
  }

  context.go('/product/$productId');
}
```

### 5. Track Deep Link Usage

Monitor which deep links are most used:
```dart
Analytics.logEvent('deep_link_opened', parameters: {
  'path': data.path,
  'source': data.queryParameters['ref'],
  'campaign': data.queryParameters['campaign'],
});
```

---

## Next Steps

1. **Test thoroughly** on both platforms
2. **Add analytics** to track deep link usage
3. **Create marketing links** for campaigns
4. **Generate QR codes** for offline marketing
5. **Set up Universal Links** for production

---

## Additional Resources

- [Flutter uni_links package](https://pub.dev/packages/uni_links)
- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [GoRouter Deep Linking](https://gorouter.dev/deep-linking)

---

## Need Help?

- 📚 Check the [Flyer Documentation](https://github.com/your-repo/flyer)
- 🐛 Report issues on [GitHub](https://github.com/your-repo/flyer/issues)
- 💬 Join our community

---

**Generated with Flyer CLI** 🚀
