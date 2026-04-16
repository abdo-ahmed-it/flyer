import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/format_code.dart';

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
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
        print('${ColorsText.cyan}          Formatting Code${ColorsText.reset}');
        print(
            '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
        formatCode();
      }

      if (argResults!.arguments.isEmpty) {
        print(
            '${ColorsText.yellow}No valid options provided.${ColorsText.reset}');
        print(
            '${ColorsText.yellow}Use --help for usage information.${ColorsText.reset}');
      }
    } else {
      print('${ColorsText.yellow}No arguments found.${ColorsText.reset}');
      print(
          '${ColorsText.yellow}Use --help for usage information.${ColorsText.reset}');
    }
  }
}
