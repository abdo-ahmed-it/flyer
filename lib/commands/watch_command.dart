import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/watch_localization.dart';

class WatchCommand extends Command {
  WatchCommand() {
    argParser.addFlag(
      'loc',
      help: 'Watch for missing localization keys and auto-add them',
      negatable: false,
    );
    argParser.addOption(
      'debounce',
      help: 'Debounce time in seconds (default: 2)',
      defaultsTo: '2',
    );
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Show detailed logs',
      negatable: false,
    );
  }

  @override
  String get description =>
      'Watch files for changes and auto-generate missing localization keys';

  @override
  String get name => 'watch';

  @override
  Future<void> run() async {
    if (argResults == null) {
      print('${ColorsText.yellow}Usage: flyer watch [options]${ColorsText.reset}');
      print(argParser.usage);
      return;
    }

    bool watchLoc = argResults!['loc'] ?? false;
    bool verbose = argResults!['verbose'] ?? false;
    int debounceSeconds = int.tryParse(argResults!['debounce']) ?? 2;

    if (!watchLoc) {
      print('${ColorsText.yellow}No watch option specified${ColorsText.reset}');
      print('${ColorsText.blue}Usage: flyer watch --loc [--verbose]${ColorsText.reset}\n');
      print(argParser.usage);
      return;
    }

    await watchLocalization(
      debounceSeconds: debounceSeconds,
      verbose: verbose,
    );
  }
}