import 'package:args/command_runner.dart';
import 'package:flyer/functions/ci/ci_ios_setup.dart';

class CiCommand extends Command {
  CiCommand() {
    addSubcommand(CiIosCommand());
  }

  @override
  String get description =>
      'Generate CI/CD workflows (iOS TestFlight via GitHub Actions + Fastlane)';

  @override
  String get name => 'ci';
}

class CiIosCommand extends Command {
  CiIosCommand() {
    argParser.addFlag(
      'shorebird',
      negatable: false,
      help: 'Enable Shorebird code push (runs shorebird init if needed)',
    );
    argParser.addFlag(
      'dry-run',
      negatable: false,
      help: 'Show planned changes without writing any files',
    );
    argParser.addFlag(
      'yes',
      abbr: 'y',
      negatable: false,
      help: 'Skip confirmation prompt',
    );
    argParser.addOption(
      'bundle-id',
      help: 'Override the auto-detected iOS bundle identifier',
      valueHelp: 'com.example.app',
    );
    argParser.addOption(
      'team-id',
      help: 'Override the auto-detected Apple Developer Team ID',
      valueHelp: 'ABCDE12345',
    );
    argParser.addOption(
      'match-git-url',
      help: 'URL of the Fastlane match certificates repo '
          '(will be prompted if omitted)',
      valueHelp: 'https://github.com/you/ios_cer.git',
    );
  }

  @override
  String get description =>
      'Scaffold GitHub Actions + Fastlane deployment to TestFlight';

  @override
  String get name => 'ios';

  @override
  Future<void> run() async {
    final results = argResults!;
    final options = CiIosOptions(
      shorebird: results['shorebird'] as bool,
      dryRun: results['dry-run'] as bool,
      assumeYes: results['yes'] as bool,
      bundleIdOverride: results['bundle-id'] as String?,
      teamIdOverride: results['team-id'] as String?,
      matchGitUrl: results['match-git-url'] as String?,
    );

    final setup = CiIosSetup(options: options);
    final code = await setup.run();
    if (code != 0) {
      throw UsageException('flyer ci:ios failed (exit $code)', usage);
    }
  }
}
