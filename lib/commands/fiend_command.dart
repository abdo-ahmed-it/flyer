import 'package:args/command_runner.dart';
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
      if (argResults!['unusedAssets'] != null) {
        fiendUnusedAssets();
      }

      if (argResults!['unusedPackages'] != null) {
        fiendUnusedPackages();
      }
      if (argResults!['unusedFiles'] != null) {
        findUnusedFiles();
      }

      if (argResults!.arguments.isEmpty) {
        print('No arguments found.\nUse: flyer fiend [options]');
        print(argParser.usage);
      }
    } else {
      print('No arguments found.\n Use: flyer fiend [options]');
      print(argParser.usage);
    }
  }
}
