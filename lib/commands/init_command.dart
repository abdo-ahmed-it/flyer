import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/constants/packages_name.dart';
import 'package:flyer/creators.dart';
import 'package:flyer/functions/install_package.dart';
import 'package:flyer/functions/run_pub_get.dart';

class InitCommand extends Command {
  InitCommand() {
    argParser.addMultiOption(
      'lang',
      help: 'Set the language for initialization',
      defaultsTo: ['en', 'ar'],
    );
    argParser.addFlag(
      'firebase',
      help: 'Setup Firebase (installs firebase_core and runs flutterfire configure)',
      negatable: false,
    );
  }

  @override
  String get description => 'Init Flutter Project (Infra Structure)';

  @override
  String get name => 'init';

  @override
  void run() async {
    print(
        '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
    print(
        '${ColorsText.cyan}          Flutter Project Initialization${ColorsText.reset}');
    print(
        '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');

    bool useFirebase = argResults?['firebase'] ?? false;

    print(
        '${ColorsText.blue}📁 Creating project structure...${ColorsText.reset}\n');
    await Creators.init(firebase: useFirebase);

    if (argResults != null) {
      List<String> lang = argResults!['lang'];
      if (lang.isNotEmpty) {
        print(
            '\n${ColorsText.blue}🌍 Adding localizations...${ColorsText.reset}');
        await Creators.addLang(languages: lang);
      }
    }

    print('\n${ColorsText.blue}📦 Installing packages...${ColorsText.reset}');
    for (var package in PackagesName().initPackages) {
      await installPackage(package);
    }

    print(
        '\n${ColorsText.blue}🔧 Installing dependency overrides...${ColorsText.reset}');
    for (var package in PackagesName().dependencyOverrides) {
      await installPackageAsOverride(package);
    }

    if (useFirebase) {
      print(
          '\n${ColorsText.blue}🔥 Setting up Firebase...${ColorsText.reset}');
      await installPackage('firebase_core');
    }

    await runPubGet();
    await Process.run(
      'flutter',
      ['gen-l10n'],
      workingDirectory: Directory.current.path,
    );

    if (useFirebase) {
      print(
          '\n${ColorsText.blue}🔥 Running flutterfire configure...${ColorsText.reset}\n');
      var result = await Process.start(
        'flutterfire',
        ['configure'],
        workingDirectory: Directory.current.path,
        mode: ProcessStartMode.inheritStdio,
      );
      await result.exitCode;
    }

    print(
        '\n${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}');
    print(
        '${ColorsText.green}          ✅ Project initialized successfully!${ColorsText.reset}');
    print(
        '${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
  }
}
