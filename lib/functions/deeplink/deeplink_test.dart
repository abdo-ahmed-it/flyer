import 'dart:io';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/deeplink/extract_project_info.dart';

Future<void> testDeeplink({
  String? url,
  bool testAndroid = false,
  bool testIos = false,
  String? scheme,
}) async {
  print(
      '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
  print('${ColorsText.cyan}          Deep Link Testing${ColorsText.reset}');
  print(
      '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');

  // If no specific platform is selected, show both
  final testBoth = !testAndroid && !testIos;

  if (url == null && scheme == null) {
    print(
        '${ColorsText.red}Error: You must specify either --url or --scheme${ColorsText.reset}');
    print('\nUsage: flyer deeplink test --url <url>');
    print('   or: flyer deeplink test --scheme <scheme> --url <path>');
    return;
  }

  // Build test URL
  String testUrl;
  if (scheme != null) {
    testUrl = '$scheme://${url ?? ''}';
  } else {
    testUrl = url!;
  }

  print(
      '${ColorsText.blue}🧪 Test URL: ${ColorsText.cyan}$testUrl${ColorsText.reset}\n');

  // Extract project info for package names
  final projectInfo = await extractProjectInfo();

  // Test Android
  if (testAndroid || testBoth) {
    await _testAndroid(testUrl, projectInfo.androidPackageName);
  }

  // Test iOS
  if (testIos || testBoth) {
    _showIosTestInstructions(testUrl);
  }

  // Show verification commands
  if (testBoth || testAndroid) {
    _showAndroidVerification(projectInfo.androidPackageName);
  }
}

Future<void> _testAndroid(String url, String? packageName) async {
  print('${ColorsText.blue}📱 Testing Android...${ColorsText.reset}\n');

  // Check if adb is available
  try {
    final adbCheck = await Process.run('adb', ['version']);
    if (adbCheck.exitCode != 0) {
      print(
          '${ColorsText.red}Error: adb not found. Please install Android SDK Platform-Tools${ColorsText.reset}');
      return;
    }
  } catch (e) {
    print(
        '${ColorsText.red}Error: adb not found. Please install Android SDK Platform-Tools${ColorsText.reset}');
    return;
  }

  // Check if device is connected
  final devicesResult = await Process.run('adb', ['devices']);
  final devices = devicesResult.stdout.toString();

  if (!devices.contains('device') ||
      devices.split('\n').where((line) => line.contains('device')).length < 2) {
    print(
        '${ColorsText.yellow}⚠ No Android device detected${ColorsText.reset}');
    print(
        '${ColorsText.yellow}  Please connect a device or start an emulator${ColorsText.reset}\n');
    _showAndroidManualTest(url);
    return;
  }

  print('${ColorsText.green}✓ Android device detected${ColorsText.reset}\n');

  // Launch the deep link
  print('${ColorsText.blue}Launching deep link...${ColorsText.reset}');
  final result = await Process.run('adb', [
    'shell',
    'am',
    'start',
    '-a',
    'android.intent.action.VIEW',
    '-d',
    url,
  ]);

  if (result.exitCode == 0) {
    print(
        '${ColorsText.green}✓ Deep link launched successfully${ColorsText.reset}');
    print('${ColorsText.gray}${result.stdout}${ColorsText.reset}');
  } else {
    print('${ColorsText.red}✗ Failed to launch deep link${ColorsText.reset}');
    print('${ColorsText.red}${result.stderr}${ColorsText.reset}');
  }

  print('');
}

void _showAndroidManualTest(String url) {
  print('${ColorsText.cyan}Manual Testing:${ColorsText.reset}');
  print(
      '  Run: ${ColorsText.gray}adb shell am start -a android.intent.action.VIEW -d "$url"${ColorsText.reset}\n');
}

void _showIosTestInstructions(String url) {
  print('${ColorsText.blue}🍎 Testing iOS...${ColorsText.reset}\n');
  print(
      '${ColorsText.yellow}Note: iOS deep links cannot be tested directly from command line${ColorsText.reset}\n');
  print('${ColorsText.cyan}Manual Testing Options:${ColorsText.reset}\n');
  print(
      '  1. ${ColorsText.gray}Open Notes app → Create new note → Type: $url → Tap the link${ColorsText.reset}\n');
  print(
      '  2. ${ColorsText.gray}Open Safari → Type in address bar: $url → Go${ColorsText.reset}\n');
  print(
      '  3. ${ColorsText.gray}Send link via Messages/Mail → Tap the link${ColorsText.reset}\n');
  print(
      '  4. ${ColorsText.gray}Using Terminal (requires simctl):${ColorsText.reset}');
  print(
      '     ${ColorsText.gray}xcrun simctl openurl booted "$url"${ColorsText.reset}\n');
}

void _showAndroidVerification(String? packageName) {
  print('${ColorsText.blue}🔍 Verification Commands:${ColorsText.reset}\n');

  if (packageName != null) {
    print(
        '  • ${ColorsText.cyan}Check App Links verification status:${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}adb shell pm get-app-links $packageName${ColorsText.reset}\n');

    print(
        '  • ${ColorsText.cyan}Manually verify domain (Android 12+):${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}adb shell pm verify-app-links --re-verify $packageName${ColorsText.reset}\n');
  }

  print(
      '  • ${ColorsText.cyan}View logcat for deep link events:${ColorsText.reset}');
  print(
      '    ${ColorsText.gray}adb logcat | grep -i "deep"${ColorsText.reset}\n');

  print(
      '  • ${ColorsText.cyan}Test with Chrome Custom Tabs:${ColorsText.reset}');
  print(
      '    ${ColorsText.gray}adb shell am start -a android.intent.action.VIEW \\');
  print('      -c android.intent.category.BROWSABLE \\');
  print('      -d "https://your-domain.com/path"${ColorsText.reset}\n');
}
