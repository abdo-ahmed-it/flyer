import 'dart:io';

import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/core/constants/packages_name.dart';
import 'package:app_creator/creatores.dart';
import 'package:app_creator/functions/install_package.dart';
import 'package:args/command_runner.dart';

class InitCommand extends Command {
  InitCommand() {
    argParser.addMultiOption(
      'lang',
      help: 'Set the language for initialization',
      // defaultsTo: ['en'],
    );
  }

  @override
  String get description => 'Init Flutter Project (Infra Structure)';

  @override
  String get name => 'init';

  @override
  void run() async {
    Creators.init();
    if (argResults != null) {
      List<String> lang = argResults!['lang'];
      if (lang.isNotEmpty) {
        await Creators.addLang(languages: lang);
      }
    }
    print('Install Packages\n Loading... ');
    for (var package in PackagesName().initPackages) {
      await installPackage(package);
    }
    print(
        '${ColorsText.green}Infra Structure created successfully${ColorsText.reset}');
    Process.runSync('pub', ['get']);
  }
}
