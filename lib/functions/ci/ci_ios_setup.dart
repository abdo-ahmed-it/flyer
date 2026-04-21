import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/ci/project_detector.dart';
import 'package:flyer/functions/ci/templates.dart';

class CiIosOptions {
  final bool shorebird;
  final bool dryRun;
  final bool assumeYes;
  final String? bundleIdOverride;
  final String? teamIdOverride;
  final String? matchGitUrl;

  CiIosOptions({
    this.shorebird = false,
    this.dryRun = false,
    this.assumeYes = false,
    this.bundleIdOverride,
    this.teamIdOverride,
    this.matchGitUrl,
  });
}

class CiIosSetup {
  final CiIosOptions options;
  final String projectRoot;

  CiIosSetup({required this.options, this.projectRoot = '.'});

  Future<int> run() async {
    _header();

    if (!_checkPrerequisites()) return 1;

    final info = _resolveProjectInfo();
    if (info == null) return 1;

    if (options.shorebird && !await _ensureShorebird(info)) return 1;

    final matchUrl = _resolveMatchUrl();
    if (matchUrl == null) return 1;

    _printPlan(info, matchUrl);

    if (!_confirm()) {
      _info('Aborted.');
      return 0;
    }

    _writeFiles(info, matchUrl);
    _patchPodfile();
    _patchAndroidManifest();
    _patchGitignore();

    _printNextSteps(info, matchUrl);
    return 0;
  }

  // ─── Prerequisites ───────────────────────────────────────────────────────

  bool _checkPrerequisites() {
    _section('Checking prerequisites');

    if (!ProjectDetector.isFlutterProject(projectRoot)) {
      _error('Not a Flutter project (no pubspec.yaml in current directory).');
      return false;
    }
    _ok('Flutter project detected');

    if (!ProjectDetector.hasIosPlatform(projectRoot)) {
      _error('iOS platform not configured.');
      _hint('Run: flutter create --platforms=ios .');
      return false;
    }
    _ok('iOS platform configured');

    if (_which('flutter') == null) {
      _warn('flutter not found in PATH (will be required at CI time)');
    } else {
      _ok('flutter CLI available');
    }

    if (_which('xcodebuild') == null) {
      _warn('xcodebuild not found (will be required at CI time)');
    } else {
      _ok('Xcode CLI tools available');
    }

    if (options.shorebird) {
      if (_which('shorebird') == null) {
        _error('Shorebird CLI not found.');
        _hint(
            r"Install: curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | sh");
        return false;
      }
      _ok('Shorebird CLI available');
    }

    return true;
  }

  // ─── Project info resolution ─────────────────────────────────────────────

  ProjectInfo? _resolveProjectInfo() {
    _section('Detecting project settings');
    final detected = ProjectDetector.detect(projectRoot: projectRoot);

    final bundleId = options.bundleIdOverride ?? detected.bundleId;
    final teamId = options.teamIdOverride ?? detected.teamId;

    if (bundleId == null || bundleId.isEmpty) {
      _error('Could not detect Bundle ID from Runner.xcodeproj.');
      _hint('Pass it with --bundle-id <id>');
      return null;
    }
    _ok('Bundle ID: $bundleId');

    if (teamId == null || teamId.isEmpty) {
      _error('Could not detect Team ID from Runner.xcodeproj.');
      _hint('Pass it with --team-id <id>');
      return null;
    }
    _ok('Team ID: $teamId');

    if (detected.flutterProjectName != null) {
      _ok('Flutter project name: ${detected.flutterProjectName}');
    }

    return ProjectInfo(
      bundleId: bundleId,
      teamId: teamId,
      flutterProjectName: detected.flutterProjectName,
      shorebirdAppId: detected.shorebirdAppId,
    );
  }

  // ─── Shorebird init ──────────────────────────────────────────────────────

  Future<bool> _ensureShorebird(ProjectInfo info) async {
    _section('Setting up Shorebird');

    final yaml = File('$projectRoot/shorebird.yaml');
    if (yaml.existsSync()) {
      _ok('shorebird.yaml already exists (app_id: ${info.shorebirdAppId})');
      return true;
    }

    if (options.dryRun) {
      _info('[dry-run] Would run: shorebird init');
      return true;
    }

    _info('Running: shorebird init');
    final result = await Process.start(
      'shorebird',
      ['init'],
      workingDirectory: projectRoot,
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await result.exitCode;
    if (code != 0) {
      _error('shorebird init failed (exit $code).');
      return false;
    }
    _ok('shorebird init completed');
    return true;
  }

  // ─── Match URL resolution ────────────────────────────────────────────────

  String? _resolveMatchUrl() {
    if (options.matchGitUrl != null && options.matchGitUrl!.isNotEmpty) {
      return options.matchGitUrl;
    }

    // Try to read existing Matchfile
    final existing = File('$projectRoot/ios/fastlane/Matchfile');
    if (existing.existsSync()) {
      final content = existing.readAsStringSync();
      final match = RegExp(r'git_url\([^"]*"([^"]+)"').firstMatch(content);
      if (match != null) return match.group(1);
    }

    // Prompt
    stdout.write(
        '${ColorsText.yellow}?${ColorsText.reset} Match git URL (e.g. https://github.com/you/ios_cer.git): ');
    final input = stdin.readLineSync()?.trim();
    if (input == null || input.isEmpty) {
      _error('Match git URL is required.');
      _hint('Pass it with --match-git-url <url>');
      return null;
    }
    return input;
  }

  // ─── Plan + confirm ──────────────────────────────────────────────────────

  void _printPlan(ProjectInfo info, String matchUrl) {
    _section('Planned changes');
    final files = [
      '.github/workflows/deploy.yml',
      'ios/fastlane/Fastfile',
      'ios/fastlane/Appfile',
      'ios/fastlane/Matchfile',
      if (options.shorebird) 'ios/fastlane/Pluginfile',
      'ios/ExportOptions.plist',
      'ios/Gemfile',
    ];
    for (final f in files) {
      final exists = File('$projectRoot/$f').existsSync();
      final prefix = exists
          ? '${ColorsText.yellow}~${ColorsText.reset}'
          : '${ColorsText.green}+${ColorsText.reset}';
      stdout.writeln('  $prefix $f');
    }
    stdout.writeln(
        '  ${ColorsText.yellow}~${ColorsText.reset} ios/Podfile (post_install block)');
    stdout.writeln(
        '  ${ColorsText.yellow}~${ColorsText.reset} .gitignore (add fastlane artifacts)');
    if (options.shorebird) {
      stdout.writeln(
          '  ${ColorsText.yellow}~${ColorsText.reset} android/app/src/main/AndroidManifest.xml (INTERNET permission)');
    }
    stdout.writeln();
    stdout.writeln('  Match repo: $matchUrl');
    stdout.writeln('  Default lane: ${options.shorebird ? 'release_shorebird' : 'deploy'}');
    stdout.writeln();
  }

  bool _confirm() {
    if (options.dryRun) {
      _info('[dry-run] No files will be written.');
      return false;
    }
    if (options.assumeYes) return true;

    stdout.write(
        '${ColorsText.yellow}?${ColorsText.reset} Continue? [y/N] ');
    final answer = stdin.readLineSync()?.trim().toLowerCase();
    return answer == 'y' || answer == 'yes';
  }

  // ─── File writing ────────────────────────────────────────────────────────

  void _writeFiles(ProjectInfo info, String matchUrl) {
    _section('Writing files');

    final vars = {
      'BUNDLE_ID': info.bundleId!,
      'TEAM_ID': info.teamId!,
      'FLUTTER_VERSION': _readFlutterVersion() ?? '3.41.2',
      'DEFAULT_LANE':
          options.shorebird ? 'release_shorebird' : 'deploy',
      'MATCH_GIT_URL': matchUrl,
    };

    _write('.github/workflows/deploy.yml',
        CiTemplates.render(CiTemplates.workflow, vars));
    _write('ios/fastlane/Fastfile',
        CiTemplates.render(CiTemplates.fastfile, vars));
    _write(
        'ios/fastlane/Appfile', CiTemplates.render(CiTemplates.appfile, vars));
    _write('ios/fastlane/Matchfile',
        CiTemplates.render(CiTemplates.matchfile, vars));
    _write('ios/ExportOptions.plist',
        CiTemplates.render(CiTemplates.exportOptions, vars));
    _write('ios/Gemfile', CiTemplates.gemfile);

    if (options.shorebird) {
      _write('ios/fastlane/Pluginfile', CiTemplates.pluginfile);
    }
  }

  void _patchPodfile() {
    final file = File('$projectRoot/ios/Podfile');
    if (!file.existsSync()) {
      _warn('ios/Podfile not found — skipping post_install patch');
      return;
    }
    var content = file.readAsStringSync();
    const marker = '# flyer:ci:post_install';

    if (content.contains(marker)) {
      _ok('ios/Podfile (post_install already patched)');
      return;
    }

    // ignore: prefer_const_declarations
    final newBlock = '$marker\n${CiTemplates.podfilePostInstall}\n';

    final postInstallRe =
        RegExp(r'post_install\s+do\s+\|installer\|.*?\nend', dotAll: true);
    if (postInstallRe.hasMatch(content)) {
      content = content.replaceFirst(postInstallRe, newBlock);
    } else {
      content += '\n$newBlock';
    }
    file.writeAsStringSync(content);
    _ok('ios/Podfile (patched post_install)');
  }

  void _patchAndroidManifest() {
    if (!options.shorebird) return;
    final file =
        File('$projectRoot/android/app/src/main/AndroidManifest.xml');
    if (!file.existsSync()) return;

    var content = file.readAsStringSync();
    if (content.contains('android.permission.INTERNET')) {
      _ok('AndroidManifest.xml (INTERNET permission already present)');
      return;
    }
    content = content.replaceFirst(
      '<manifest',
      '<manifest',
    );
    content = content.replaceFirst(
      RegExp(r'(<manifest[^>]*>)'),
      r'$1' '\n    <uses-permission android:name="android.permission.INTERNET"/>',
    );
    file.writeAsStringSync(content);
    _ok('AndroidManifest.xml (added INTERNET permission)');
  }

  void _patchGitignore() {
    final file = File('$projectRoot/.gitignore');
    final existing = file.existsSync() ? file.readAsStringSync() : '';
    final missing = CiTemplates.gitignoreEntries
        .where((e) => !existing.contains(e))
        .toList();
    if (missing.isEmpty) {
      _ok('.gitignore (fastlane entries already present)');
      return;
    }
    final buffer = StringBuffer(existing);
    if (existing.isNotEmpty && !existing.endsWith('\n')) buffer.writeln();
    buffer.writeln();
    buffer.writeln('# Fastlane (added by flyer ci:ios)');
    for (final entry in missing) {
      buffer.writeln(entry);
    }
    file.writeAsStringSync(buffer.toString());
    _ok('.gitignore (added ${missing.length} entries)');
  }

  // ─── Next steps printout ─────────────────────────────────────────────────

  void _printNextSteps(ProjectInfo info, String matchUrl) {
    _section('Next steps');

    final secrets = <String>[
      'APP_STORE_CONNECT_API_KEY_ID',
      'APP_STORE_CONNECT_API_ISSUER_ID',
      'APP_STORE_CONNECT_API_KEY_CONTENT  (base64 of your .p8 file)',
      'MATCH_PASSWORD',
      'MATCH_GIT_URL                      → $matchUrl',
      'MATCH_GIT_BASIC_AUTHORIZATION      (base64 of "user:PAT")',
      'KEYCHAIN_PASSWORD                  (random string, anything works)',
      if (options.shorebird)
        'SHOREBIRD_TOKEN                    (from Shorebird Console → API Keys)',
      'LARK_WEBHOOK                       (optional — Lark bot webhook URL; leave unset to skip notifications)',
    ];

    stdout.writeln('1. One-time Apple Developer setup (if not done yet):');
    stdout.writeln('   • Create the app in App Store Connect:');
    stdout.writeln('     https://appstoreconnect.apple.com');
    stdout.writeln('   • Generate an App Store Connect API Key (.p8):');
    stdout.writeln('     https://appstoreconnect.apple.com/access/api');
    stdout.writeln();
    stdout.writeln('2. First match certificate setup (locally, once per Apple team):');
    stdout.writeln('     cd ios');
    stdout.writeln('     bundle install');
    stdout.writeln('     bundle exec fastlane match appstore');
    stdout.writeln('   (reuse MATCH_PASSWORD across all projects sharing this match repo)');
    stdout.writeln();
    stdout.writeln('3. Add these GitHub Secrets (Settings → Secrets → Actions):');
    for (final s in secrets) {
      stdout.writeln('     • $s');
    }
    stdout.writeln();
    stdout.writeln('4. Trigger your first deploy:');
    stdout.writeln('     GitHub → Actions → "Deploy iOS to TestFlight" → Run workflow');
    stdout.writeln();
    _ok('Done.');
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String? _readFlutterVersion() {
    final pubspec = File('$projectRoot/pubspec.yaml');
    if (!pubspec.existsSync()) return null;
    // We intentionally use a fixed known-good Flutter version in the workflow
    // instead of deriving from SDK constraint; the user can edit if needed.
    return null;
  }

  String? _which(String binary) {
    final paths = Platform.environment['PATH']?.split(':') ?? const [];
    for (final p in paths) {
      final candidate = File('$p/$binary');
      if (candidate.existsSync()) return candidate.path;
    }
    return null;
  }

  void _write(String relPath, String content) {
    final file = File('$projectRoot/$relPath');
    file.parent.createSync(recursive: true);
    final exists = file.existsSync();
    file.writeAsStringSync(content);
    _ok('${exists ? 'updated' : 'created'} $relPath');
  }

  // ─── Printing helpers ────────────────────────────────────────────────────

  void _header() {
    stdout.writeln(
        '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
    stdout.writeln(
        '${ColorsText.cyan}   flyer ci:ios — TestFlight deploy via GitHub Actions${ColorsText.reset}');
    stdout.writeln(
        '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
  }

  void _section(String title) {
    stdout.writeln();
    stdout.writeln('${ColorsText.cyan}▶ $title${ColorsText.reset}');
  }

  void _ok(String msg) =>
      stdout.writeln('  ${ColorsText.green}✓${ColorsText.reset} $msg');
  void _warn(String msg) =>
      stdout.writeln('  ${ColorsText.yellow}!${ColorsText.reset} $msg');
  void _error(String msg) =>
      stdout.writeln('  ${ColorsText.red}✗${ColorsText.reset} $msg');
  void _info(String msg) =>
      stdout.writeln('  ${ColorsText.gray}$msg${ColorsText.reset}');
  void _hint(String msg) =>
      stdout.writeln('    ${ColorsText.gray}→ $msg${ColorsText.reset}');
}
