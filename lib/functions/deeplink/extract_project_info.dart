import 'dart:async';
import 'dart:io';
import 'package:flyer/core/colors_text.dart';

class ProjectInfo {
  String? androidPackageName;
  String? iosBundleId;
  String? iosTeamId;
  String? debugSha256;

  ProjectInfo({
    this.androidPackageName,
    this.iosBundleId,
    this.iosTeamId,
    this.debugSha256,
  });
}

/// Extract Android package name from build.gradle or build.gradle.kts
Future<String?> extractAndroidPackageName() async {
  // Try Kotlin DSL first (newer Flutter versions)
  File buildGradleFile = File('android/app/build.gradle.kts');
  bool isKotlinDsl = true;

  if (!buildGradleFile.existsSync()) {
    // Fallback to Groovy (older Flutter versions)
    buildGradleFile = File('android/app/build.gradle');
    isKotlinDsl = false;

    if (!buildGradleFile.existsSync()) {
      print(
          '${ColorsText.yellow}Warning: android/app/build.gradle or build.gradle.kts not found${ColorsText.reset}');
      return null;
    }
  }

  final content = await buildGradleFile.readAsString();

  // Kotlin DSL uses: applicationId = "com.example.app"
  // Groovy uses: applicationId "com.example.app" or applicationId 'com.example.app'
  RegExp regex;
  if (isKotlinDsl) {
    regex = RegExp(r'applicationId\s*=\s*["' + "'" + r'](.+?)["' + "'" + r']');
  } else {
    regex = RegExp(r'applicationId\s+["' + "'" + r'](.+?)["' + "'" + r']');
  }

  final match = regex.firstMatch(content);

  if (match != null && match.groupCount >= 1) {
    return match.group(1);
  }

  print(
      '${ColorsText.yellow}Warning: Could not find applicationId in ${isKotlinDsl ? 'build.gradle.kts' : 'build.gradle'}${ColorsText.reset}');
  return null;
}

/// Extract iOS bundle ID from project.pbxproj
Future<String?> extractIosBundleId() async {
  final pbxprojFile = File('ios/Runner.xcodeproj/project.pbxproj');

  if (!pbxprojFile.existsSync()) {
    print(
        '${ColorsText.yellow}Warning: ios/Runner.xcodeproj/project.pbxproj not found${ColorsText.reset}');
    return null;
  }

  final content = await pbxprojFile.readAsString();
  final regex = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);');
  final matches = regex.allMatches(content);

  for (var match in matches) {
    if (match.groupCount >= 1) {
      final bundleId = match.group(1)?.trim();
      // Skip if it's a variable like $(PRODUCT_BUNDLE_IDENTIFIER)
      if (bundleId != null && !bundleId.startsWith(r'$(')) {
        return bundleId;
      }
    }
  }

  print(
      '${ColorsText.yellow}Warning: Could not find PRODUCT_BUNDLE_IDENTIFIER in project.pbxproj${ColorsText.reset}');
  return null;
}

/// Extract iOS Team ID from project.pbxproj
Future<String?> extractIosTeamId() async {
  final pbxprojFile = File('ios/Runner.xcodeproj/project.pbxproj');

  if (!pbxprojFile.existsSync()) {
    return null;
  }

  final content = await pbxprojFile.readAsString();
  final regex = RegExp(r'DEVELOPMENT_TEAM\s*=\s*([^;]+);');
  final match = regex.firstMatch(content);

  if (match != null && match.groupCount >= 1) {
    final teamId = match.group(1)?.trim();
    if (teamId != null &&
        teamId.isNotEmpty &&
        teamId != '""' &&
        teamId != "''") {
      return teamId;
    }
  }

  return null;
}

/// Extract debug SHA256 fingerprint from debug keystore
Future<String?> extractDebugSha256() async {
  // Try default location first
  final homeDir =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  if (homeDir == null) return null;

  final debugKeystorePath = '$homeDir/.android/debug.keystore';
  final debugKeystore = File(debugKeystorePath);

  if (!debugKeystore.existsSync()) {
    return null;
  }

  try {
    final result = await Process.run(
      'keytool',
      [
        '-list',
        '-v',
        '-keystore',
        debugKeystorePath,
        '-alias',
        'androiddebugkey',
        '-storepass',
        'android',
        '-keypass',
        'android',
      ],
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        throw TimeoutException('keytool command timed out');
      },
    );

    if (result.exitCode == 0) {
      final output = result.stdout.toString();
      final regex = RegExp(r'SHA256:\s*([A-F0-9:]+)');
      final match = regex.firstMatch(output);

      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
  } catch (e) {
    // keytool not available or error occurred
  }

  return null;
}

/// Extract all project information
Future<ProjectInfo> extractProjectInfo() async {
  print(
      '${ColorsText.blue}🔍 Extracting project information...${ColorsText.reset}\n');

  final info = ProjectInfo(
    androidPackageName: await extractAndroidPackageName(),
    iosBundleId: await extractIosBundleId(),
    iosTeamId: await extractIosTeamId(),
    debugSha256: await extractDebugSha256(),
  );

  return info;
}
