import 'package:app_creator/commands/fiend_command.dart';
import 'package:app_creator/commands/init_command.dart';
import 'package:app_creator/commands/make_command.dart';
import 'package:app_creator/commands/run_command.dart';
import 'package:app_creator/core/colors_text.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('tool', 'A command line tool')
    ..addCommand(InitCommand())
    ..addCommand(MakeCommand())
    ..addCommand(FiendCommand())
    ..addCommand(RunCommand());

  runner.run(arguments).catchError((error) {
    print('${ColorsText.red}Error: $error${ColorsText.reset}');
  });
}
