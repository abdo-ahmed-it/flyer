import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/deeplink/deeplink_setup.dart';
import 'package:flyer/functions/deeplink/deeplink_test.dart';

class DeeplinkCommand extends Command {
  DeeplinkCommand() {
    argParser.addOption(
      'domain',
      abbr: 'd',
      help: 'Domain for App Links and Universal Links (e.g., example.com)',
      valueHelp: 'example.com',
    );
    argParser.addOption(
      'scheme',
      abbr: 's',
      help: 'Custom URL scheme (e.g., myapp)',
      valueHelp: 'myapp',
    );
    argParser.addFlag(
      'dry-run',
      negatable: false,
      help: 'Show what will be done without making any changes',
    );
    argParser.addFlag(
      'test',
      negatable: false,
      help: 'Test deep links on connected devices',
    );
    argParser.addOption(
      'url',
      help: 'URL to test (for --test flag)',
      valueHelp: 'https://example.com/path or myapp://path',
    );
    argParser.addFlag(
      'android',
      negatable: false,
      help: 'Test on Android only (for --test flag)',
    );
    argParser.addFlag(
      'ios',
      negatable: false,
      help: 'Show iOS test instructions (for --test flag)',
    );
  }

  @override
  String get description => 'Setup and test deep linking for Android and iOS';

  @override
  String get name => 'deeplink';

  @override
  void run() async {
    if (argResults == null) {
      print('Usage: flyer deeplink [options]');
      print(argParser.usage);
      return;
    }

    bool isTest = argResults!['test'] ?? false;

    if (isTest) {
      // Test mode
      String? url = argResults!['url'];
      String? scheme = argResults!['scheme'];
      bool testAndroid = argResults!['android'] ?? false;
      bool testIos = argResults!['ios'] ?? false;

      await testDeeplink(
        url: url,
        scheme: scheme,
        testAndroid: testAndroid,
        testIos: testIos,
      );
    } else {
      // Setup mode
      String? domain = argResults!['domain'];
      String? scheme = argResults!['scheme'];
      bool isDryRun = argResults!['dry-run'] ?? false;

      if (domain == null && scheme == null) {
        print(
            '${ColorsText.red}Error: You must specify either --domain or --scheme${ColorsText.reset}');
        print('\nUsage: flyer deeplink [options]');
        print(argParser.usage);
        exit(1);
      }

      await setupDeeplink(
        domain: domain,
        scheme: scheme,
        isDryRun: isDryRun,
      );
    }
  }
}
