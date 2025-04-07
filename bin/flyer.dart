import 'package:flyer/commands/fiend_command.dart';
import 'package:flyer/commands/generate_action_command.dart';
import 'package:flyer/commands/init_command.dart';
import 'package:flyer/commands/make_command.dart';
import 'package:flyer/commands/run_command.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('tool', 'A command line tool')
    ..addCommand(InitCommand())
    ..addCommand(MakeCommand())
    ..addCommand(FiendCommand())
    ..addCommand(RunCommand())
    ..addCommand(GenerateActionsFromCollectionCommand());

  runner.run(arguments).catchError((error) {
    print('${ColorsText.red}Error: $error${ColorsText.reset}');
  });
}
