import 'package:args/command_runner.dart';
import 'package:flutter/material.dart';
import 'package:flyer/functions/formate_code.dart';

class RunCommand extends Command {
  RunCommand() {
    argParser.addOption(
      'format',
      help: 'Reformat the code',
    );
  }

  @override
  String get description => 'Run various utility tasks';

  @override
  String get name => 'run';

  @override
  void run() {
    if (argResults != null) {
      if (argResults!['format'] != null) {
        formatCode();
      }

      if (argResults!.arguments.isEmpty) {
        debugPrint(
            'No valid options provided. Use --help for usage information.');
      }
    } else {
      debugPrint('No arguments found. Use --help for usage information.');
    }
  }
}
