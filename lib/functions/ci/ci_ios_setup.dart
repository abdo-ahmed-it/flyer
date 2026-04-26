// ignore_for_file: unnecessary_brace_in_string_interps

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
    _patchInfoPlist();
    _patchRunnerScheme();
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
      '.github/dependabot.yml',
      'ios/fastlane/Fastfile',
      'ios/fastlane/Appfile',
      'ios/fastlane/Matchfile',
      'ios/fastlane/.env.example',
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
        '  ${ColorsText.yellow}~${ColorsText.reset} ios/Runner/Info.plist (ITSAppUsesNonExemptEncryption)');
    stdout.writeln(
        '  ${ColorsText.yellow}~${ColorsText.reset} ios/Runner.xcodeproj/.../Runner.xcscheme (skip simulator probe on CI)');
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
    _write('.github/dependabot.yml', CiTemplates.dependabot);
    _write('ios/fastlane/Fastfile',
        CiTemplates.render(CiTemplates.fastfile, vars));
    _write(
        'ios/fastlane/Appfile', CiTemplates.render(CiTemplates.appfile, vars));
    _write('ios/fastlane/Matchfile',
        CiTemplates.render(CiTemplates.matchfile, vars));
    _write('ios/fastlane/.env.example', CiTemplates.fastlaneEnvExample);
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

  /// Adds `ITSAppUsesNonExemptEncryption=false` to Info.plist so TestFlight
  /// stops asking the export-compliance question on every build. Safe default
  /// for apps that only use HTTPS (Apple-exempt encryption).
  void _patchInfoPlist() {
    final file = File('$projectRoot/ios/Runner/Info.plist');
    if (!file.existsSync()) {
      _warn('ios/Runner/Info.plist not found — skipping encryption flag');
      return;
    }
    var content = file.readAsStringSync();
    if (content.contains('ITSAppUsesNonExemptEncryption')) {
      _ok('Info.plist (encryption flag already present)');
      return;
    }
    // Insert right after the opening <dict> (the first one, which is the
    // top-level plist dict).
    final dictRe = RegExp(r'<dict>\s*\n');
    final m = dictRe.firstMatch(content);
    if (m == null) {
      _warn('Info.plist (could not find <dict> opening — skipped)');
      return;
    }
    final inserted =
        '${content.substring(0, m.end)}\t<key>ITSAppUsesNonExemptEncryption</key>\n\t<false/>\n${content.substring(m.end)}';
    file.writeAsStringSync(inserted);
    _ok('Info.plist (added ITSAppUsesNonExemptEncryption=false)');
  }

  /// Patches Runner.xcscheme to skip simulator probes when building on CI.
  /// On macos-26 + Xcode 26, the runner ships without an iOS simulator runtime;
  /// loading the default scheme triggers an "Unable to connect to simulator"
  /// failure even for `xcodebuild archive`. Fix is two-fold:
  ///   1. Empty <Testables> so the test action does not enumerate simulators.
  ///   2. Set buildForTesting="NO" on the BuildActionEntry — Xcode 26 probes
  ///      simulators for that flag even outside the test action.
  /// Default Flutter projects ship a stub RunnerTests target that's not used,
  /// so this is safe.
  void _patchRunnerScheme() {
    final file = File(
        '$projectRoot/ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme');
    if (!file.existsSync()) {
      _warn('Runner.xcscheme not found — skipping CI scheme patch');
      return;
    }
    var content = file.readAsStringSync();
    var changed = false;

    // 1) buildForTesting = "YES" → "NO"
    final btYes = RegExp(r'buildForTesting\s*=\s*"YES"');
    if (btYes.hasMatch(content)) {
      content = content.replaceAll(btYes, 'buildForTesting = "NO"');
      changed = true;
    }

    // 2) Empty out the <Testables> block.
    final testablesRe = RegExp(
        r'<Testables>[\s\S]*?</Testables>',
        multiLine: true);
    final match = testablesRe.firstMatch(content);
    if (match != null) {
      final current = match.group(0)!;
      // Skip if already empty
      const empty = '<Testables>\n      </Testables>';
      if (!current.replaceAll(RegExp(r'\s+'), '').endsWith('<Testables></Testables>')) {
        content = content.replaceFirst(testablesRe, empty);
        changed = true;
      }
    }

    if (!changed) {
      _ok('Runner.xcscheme (already patched for CI)');
      return;
    }
    file.writeAsStringSync(content);
    _ok('Runner.xcscheme (skipped simulator probe for CI)');
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

    final defaultLane = options.shorebird ? 'release_shorebird' : 'deploy';
    const bold = ColorsText.cyan;
    const dim = ColorsText.gray;
    const reset = ColorsText.reset;

    // ── 1. Apple Developer prerequisites ────────────────────────────────
    stdout.writeln('${bold}1) Apple Developer prerequisites$reset  ${dim}(one-time, skip if done)$reset');
    stdout.writeln('   • Register the bundle id "${info.bundleId}" in:');
    stdout.writeln('     ${dim}https://developer.apple.com/account/resources/identifiers/list$reset');
    stdout.writeln('   • Create the app in App Store Connect:');
    stdout.writeln('     ${dim}https://appstoreconnect.apple.com/apps$reset');
    stdout.writeln('   • Generate an App Store Connect API key (.p8):');
    stdout.writeln('     ${dim}https://appstoreconnect.apple.com/access/api$reset');
    stdout.writeln();

    // ── 2. GitHub Secrets ───────────────────────────────────────────────
    stdout.writeln('${bold}2) Add GitHub Secrets$reset  ${dim}(Settings → Secrets and variables → Actions)$reset');
    _printSecret('APP_STORE_CONNECT_API_KEY_ID',
        'Key ID from the .p8 you just created.');
    _printSecret('APP_STORE_CONNECT_API_ISSUER_ID',
        'Issuer ID — same page as the key ID.');
    _printSecret('APP_STORE_CONNECT_API_KEY_CONTENT',
        'base64 of the .p8 file:  base64 -i AuthKey_XXX.p8 | pbcopy');
    _printSecret('MATCH_PASSWORD',
        'Strong password — encrypts your match repo. Reuse across projects.');
    _printSecret('MATCH_GIT_URL', matchUrl);
    _printSecret('MATCH_GIT_BASIC_AUTHORIZATION',
        'Optional. Only for private match repos. base64 of "user:PAT".',
        optional: true);
    _printSecret('KEYCHAIN_PASSWORD',
        'Any random string — used for the temporary CI keychain.');
    if (options.shorebird) {
      _printSecret('SHOREBIRD_TOKEN',
          'From Shorebird Console → API Keys (https://console.shorebird.dev).');
    }
    _printSecret('LARK_WEBHOOK',
        'Optional. Lark/Feishu bot webhook URL. Leave unset to skip notifications.',
        optional: true);
    stdout.writeln();
    stdout.writeln(
        '   ${dim}Tip: projects sharing the same Apple team can reuse MATCH_PASSWORD$reset');
    stdout.writeln(
        '   ${dim}+ MATCH_GIT_URL — these are per-team, not per-project.$reset');
    stdout.writeln();

    // ── 3. First cert + profile ─────────────────────────────────────────
    stdout.writeln('${bold}3) Create the cert + provisioning profile$reset  ${dim}(one-shot, then never again)$reset');
    stdout.writeln('   Pick whichever path is easier:');
    stdout.writeln();
    stdout.writeln('   ${ColorsText.green}(a) From CI — recommended$reset');
    stdout.writeln('       GitHub → Actions → "Deploy iOS to TestFlight" → Run workflow');
    stdout.writeln('       lane:   ${ColorsText.yellow}sync_profile$reset');
    stdout.writeln('       flavor: ${ColorsText.yellow}prod$reset  ${dim}(any value works for this lane)$reset');
    stdout.writeln();
    stdout.writeln('   ${ColorsText.green}(b) Locally$reset');
    stdout.writeln('       cp ios/fastlane/.env.example ios/fastlane/.env');
    stdout.writeln('       ${dim}# fill in the same values you put in GitHub Secrets$reset');
    stdout.writeln('       cd ios && bundle install');
    stdout.writeln('       bundle exec fastlane sync_profile');
    stdout.writeln();

    // ── 4. Ship a build ─────────────────────────────────────────────────
    stdout.writeln('${bold}4) Ship your first build$reset');
    stdout.writeln('   GitHub → Actions → "Deploy iOS to TestFlight" → Run workflow');
    stdout.writeln('   lane:   ${ColorsText.yellow}$defaultLane$reset');
    stdout.writeln('   flavor: ${ColorsText.yellow}prod$reset  ${dim}(or "dev" → lib/main_dev.dart)$reset');
    stdout.writeln();

    // ── Lane cheat-sheet ────────────────────────────────────────────────
    stdout.writeln('${bold}Lane cheat-sheet$reset');
    stdout.writeln('   ${ColorsText.yellow}deploy$reset             → native build → TestFlight (~5–7 min)');
    if (options.shorebird) {
      stdout.writeln('   ${ColorsText.yellow}release_shorebird$reset  → native + Shorebird baseline → TestFlight');
      stdout.writeln('   ${ColorsText.yellow}patch_shorebird$reset    → Dart-only OTA patch (no review, ~2 min)');
    }
    stdout.writeln('   ${ColorsText.yellow}sync_profile$reset       → re-create cert + profile in match repo');
    stdout.writeln('   ${ColorsText.yellow}upload_only$reset        → re-upload an existing build/ios/ipa/Runner.ipa');
    stdout.writeln();

    // ── Save Apple Developer references ─────────────────────────────────
    stdout.writeln('${bold}Useful links$reset');
    stdout.writeln('   • Match repo:     $matchUrl');
    stdout.writeln('   • Bundle id:      ${info.bundleId}');
    stdout.writeln('   • Team id:        ${info.teamId}');
    if (info.shorebirdAppId != null) {
      stdout.writeln('   • Shorebird app:  ${info.shorebirdAppId}');
    }
    stdout.writeln();
    _ok('Setup complete. Commit the generated files and push to trigger CI.');
  }

  void _printSecret(String name, String description, {bool optional = false}) {
    final marker = optional
        ? '${ColorsText.gray}○${ColorsText.reset}'
        : '${ColorsText.green}●${ColorsText.reset}';
    stdout.writeln(
        '   $marker ${ColorsText.cyan}$name${ColorsText.reset}');
    stdout.writeln(
        '     ${ColorsText.gray}$description${ColorsText.reset}');
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
