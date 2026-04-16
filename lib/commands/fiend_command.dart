import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/find_unused_package.dart';
import 'package:flyer/functions/find_unused_assets.dart';
import 'package:flyer/functions/find_unused_file.dart';

class FiendCommand extends Command {
  FiendCommand() {
    argParser.addOption(
      'unusedAssets',
      help: 'Find unused assets and can be deleted',
    );
    argParser.addOption(
      'unusedPackages',
      help: 'Find unused packages and can be deleted',
    );
    argParser.addOption(
      'unusedFiles',
      help: 'Find unused files and can be deleted',
    );
  }

  @override
  String get description => 'Find unused assets and packages in the project.';

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
        findUnusedAssets();
      }

      if (argResults!['unusedPackages'] != null) {
        hasArguments = true;
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
        print(
            '${ColorsText.cyan}          Finding Unused Packages${ColorsText.reset}');
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
        findUnusedPackages();
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
