import 'package:args/command_runner.dart';
import 'package:flutter/material.dart';
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
    debugPrint('Install Packages\n Loading... ');
    for (var package in PackagesName().initPackages) {
      await installPackage(package);
    }
    debugPrint(
        '${ColorsText.green}Infra Structure created successfully${ColorsText.reset}');
    runPubGet();
  }
}
