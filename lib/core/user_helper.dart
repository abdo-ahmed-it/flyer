import 'package:flyer/core/colors_text.dart';

void printHelp() {
  print(
      '${ColorsText.blue}Usage:${ColorsText.reset} dart run fly <command> [options]');
  print('${ColorsText.orange}Available Commands:${ColorsText.reset}');
  print(
      '  ${ColorsText.green}init${ColorsText.reset} : Initialize infrastructure.');
  print(
      '  ${ColorsText.green}make:feature${ColorsText.reset} : Create a new feature.');
  print(
      '  ${ColorsText.green}make:page${ColorsText.reset} : Add a new page to an existing feature.');
  print(
      '  ${ColorsText.green}make:form${ColorsText.reset} : Add a form to a feature.');
  print(
      '  ${ColorsText.green}find-unused-packages${ColorsText.reset} : Find unused packages in the project.');
  print(
      '  ${ColorsText.green}find-unused-files${ColorsText.reset} : Find unused files in the project.');
  print(
      '  ${ColorsText.green}find-unused-assets${ColorsText.reset} : Find unused assets in the project.');
  print(
      '  ${ColorsText.green}extract-text-widgets${ColorsText.reset} : Extract text from Text widgets.');
  print(
      '  ${ColorsText.green}extract-arabic-text${ColorsText.reset} : Extract Arabic text from the code.');
  print(
      '  ${ColorsText.green}make:model${ColorsText.reset}  : Generate a Dart model class from JSON.');
  print(
      '  ${ColorsText.green}make:language${ColorsText.reset}  : Initialize app language setup.');
  print(
      '  ${ColorsText.green}format-code${ColorsText.reset} : Format all Dart code files.');
}
