import 'package:app_creator/functions/fiend_unused_package.dart';
import 'package:app_creator/functions/fined_unused_assets.dart';
import 'package:args/command_runner.dart';

class FiendCommand extends Command {
  FiendCommand() {
    argParser.addOption(
      'unusedAssets',
      help: 'Remove unused assets',
    );
    argParser.addOption(
      'unusedPackages',
      help: 'Remove unused packages',
    );
  }

  @override
  String get description => 'Run various utility tasks';

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

      if (argResults!.arguments.isEmpty) {
        print('No valid options provided. Use --help for usage information.');
      }
    } else {
      print('No arguments found. Use --help for usage information.');
    }
  }
}
