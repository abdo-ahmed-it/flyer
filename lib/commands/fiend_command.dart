import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/fiend_unused_package.dart';
import 'package:flyer/functions/fined_unused_assets.dart';
import 'package:flyer/functions/fined_unused_file.dart';

class FiendCommand extends Command {
  FiendCommand() {
    argParser.addOption(
      'unusedAssets',
      help: 'Fiend unused assets and can be deleted',
    );
    argParser.addOption(
      'unusedPackages',
      help: 'Fiend unused packages and can be deleted',
    );
    argParser.addOption(
      'unusedFiles',
      help: 'Fiend unused files and can be deleted',
    );
  }

  @override
  String get description => 'Fiend unused assets and packages in the project.';

  @override
  String get name => 'fiend';

  @override
  void run() {
    if (argResults != null) {
      bool hasArguments = false;

      if (argResults!['unusedAssets'] != null) {
        hasArguments = true;
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
        print(
            '${ColorsText.cyan}          Finding Unused Assets${ColorsText.reset}');
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
        fiendUnusedAssets();
      }

      if (argResults!['unusedPackages'] != null) {
        hasArguments = true;
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
        print(
            '${ColorsText.cyan}          Finding Unused Packages${ColorsText.reset}');
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
        fiendUnusedPackages();
      }

      if (argResults!['unusedFiles'] != null) {
        hasArguments = true;
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
        print(
            '${ColorsText.cyan}          Finding Unused Files${ColorsText.reset}');
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
        findUnusedFiles();
      }

      if (!hasArguments) {
        print('${ColorsText.yellow}No arguments found.${ColorsText.reset}');
        print(
            '${ColorsText.yellow}Use: flyer fiend [options]${ColorsText.reset}\n');
        print(argParser.usage);
      }
    } else {
      print('${ColorsText.yellow}No arguments found.${ColorsText.reset}');
      print(
          '${ColorsText.yellow}Use: flyer fiend [options]${ColorsText.reset}\n');
      print(argParser.usage);
    }
  }
}
