import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/constants/packages_name.dart';
import 'package:flyer/creatores.dart';
import 'package:flyer/functions/install_package.dart';
import 'package:flyer/functions/run_pub_get.dart';

class InitCommand extends Command {
  InitCommand() {
    argParser.addMultiOption(
      'lang',
      help: 'Set the language for initialization',
      defaultsTo: ['en', 'ar'],
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

    print(
        '${ColorsText.blue}📁 Creating project structure...${ColorsText.reset}\n');
    Creators.init();

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

   await runPubGet();
    await Process.run(
      'flutter',
      ['gen-l10n'],
      workingDirectory: Directory.current.path,
    );


    print(
        '\n${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}');
    print(
        '${ColorsText.green}          ✅ Project initialized successfully!${ColorsText.reset}');
    print(
        '${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
  }
}
