import 'package:flutter/material.dart';
import 'package:flyer/core/colors_text.dart';

void debugPrintHelp() {
  debugPrint(
      '${ColorsText.blue}Usage:${ColorsText.reset} dart run fly <command> [options]');
  debugPrint('${ColorsText.orange}Available Commands:${ColorsText.reset}');
  debugPrint(
      '  ${ColorsText.green}init${ColorsText.reset} : Initialize infrastructure.');
  debugPrint(
      '  ${ColorsText.green}make:feature${ColorsText.reset} : Create a new feature.');
  debugPrint(
      '  ${ColorsText.green}make:page${ColorsText.reset} : Add a new page to an existing feature.');
  debugPrint(
      '  ${ColorsText.green}make:form${ColorsText.reset} : Add a form to a feature.');
  debugPrint(
      '  ${ColorsText.green}find-unused-packages${ColorsText.reset} : Find unused packages in the project.');
  debugPrint(
      '  ${ColorsText.green}find-unused-files${ColorsText.reset} : Find unused files in the project.');
  debugPrint(
      '  ${ColorsText.green}find-unused-assets${ColorsText.reset} : Find unused assets in the project.');
  debugPrint(
      '  ${ColorsText.green}extract-text-widgets${ColorsText.reset} : Extract text from Text widgets.');
  debugPrint(
      '  ${ColorsText.green}extract-arabic-text${ColorsText.reset} : Extract Arabic text from the code.');
  debugPrint(
      '  ${ColorsText.green}make:model${ColorsText.reset}  : Generate a Dart model class from JSON.');
  debugPrint(
      '  ${ColorsText.green}make:language${ColorsText.reset}  : Initialize app language setup.');
  debugPrint(
      '  ${ColorsText.green}format-code${ColorsText.reset} : Format all Dart code files.');
}
