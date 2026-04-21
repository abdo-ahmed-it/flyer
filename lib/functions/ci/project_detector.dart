import 'dart:io';

class ProjectInfo {
  final String? bundleId;
  final String? teamId;
  final String? flutterProjectName;
  final String? shorebirdAppId;

  ProjectInfo({
    this.bundleId,
    this.teamId,
    this.flutterProjectName,
    this.shorebirdAppId,
  });

  bool get hasBundleId => bundleId != null && bundleId!.isNotEmpty;
  bool get hasTeamId => teamId != null && teamId!.isNotEmpty;
}

class ProjectDetector {
  static ProjectInfo detect({String projectRoot = '.'}) {
    return ProjectInfo(
      bundleId: _readBundleId(projectRoot),
      teamId: _readTeamId(projectRoot),
      flutterProjectName: _readFlutterName(projectRoot),
      shorebirdAppId: _readShorebirdAppId(projectRoot),
    );
  }

  static bool isFlutterProject(String projectRoot) {
    return File('$projectRoot/pubspec.yaml').existsSync();
  }

  static bool hasIosPlatform(String projectRoot) {
    return File('$projectRoot/ios/Runner.xcodeproj/project.pbxproj')
        .existsSync();
  }

  static String? _readBundleId(String projectRoot) {
    final pbxproj =
        File('$projectRoot/ios/Runner.xcodeproj/project.pbxproj');
    if (!pbxproj.existsSync()) return null;

    final content = pbxproj.readAsStringSync();
    final matches = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;\s]+);')
        .allMatches(content);

    for (final match in matches) {
      final value = match.group(1);
      if (value == null) continue;
      if (value.endsWith('.RunnerTests')) continue;
      if (value.contains(r'$')) continue; // skip variables
      return value;
    }
    return null;
  }

  static String? _readTeamId(String projectRoot) {
    final pbxproj =
        File('$projectRoot/ios/Runner.xcodeproj/project.pbxproj');
    if (!pbxproj.existsSync()) return null;

    final content = pbxproj.readAsStringSync();
    final match =
        RegExp(r'DEVELOPMENT_TEAM\s*=\s*([^;\s"]+);').firstMatch(content);
    final value = match?.group(1);
    if (value == null || value.isEmpty || value == '""') return null;
    return value;
  }

  static String? _readFlutterName(String projectRoot) {
    final pubspec = File('$projectRoot/pubspec.yaml');
    if (!pubspec.existsSync()) return null;

    final content = pubspec.readAsStringSync();
    final match = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(content);
    return match?.group(1);
  }

  static String? _readShorebirdAppId(String projectRoot) {
    final file = File('$projectRoot/shorebird.yaml');
    if (!file.existsSync()) return null;

    final content = file.readAsStringSync();
    final match =
        RegExp(r'^app_id:\s*(\S+)', multiLine: true).firstMatch(content);
    return match?.group(1);
  }
}
