import 'package:flyer/functions/formate_code.dart';
import 'package:args/command_runner.dart';

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
        print('No valid options provided. Use --help for usage information.');
      }
    } else {
      print('No arguments found. Use --help for usage information.');
    }
  }
}
