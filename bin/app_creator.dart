import 'dart:io';
import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/creatores.dart';
import 'package:app_creator/functions/fined_unused_file.dart';
import 'package:app_creator/functions/fiend_unused_package.dart';

void main() async {
  stdout.write("${ColorsText.blue}Select an option:${ColorsText.reset}\n");
  stdout.write("${ColorsText.green}1. Create Infra Structure\n");
  stdout.write("${ColorsText.green}2. Create Feature\n");
  stdout.write("${ColorsText.green}3. Add Page in Feature\n");
  stdout.write("${ColorsText.green}4. Add form in Feature \n");
  stdout.write("${ColorsText.green}5. Fiend Unused Package \n");
  stdout.write("${ColorsText.green}6. Fiend Unused File ${ColorsText.reset}\n");

  String? option = stdin.readLineSync();

  switch (option) {
    case '1':
      Creators.init();
      break;
    case '2':
      Creators.createFeature();
      break;
    case '3':
      Creators.addPage();
      break;
    case '4':
      Creators.addForm();
      break;

    case '5':
      fiendUnusedPackages();
      break;
    case '6':
      findUnusedFiles();
      break;
    default:
      stdout.write(
          "${ColorsText.red}Invalid selection.\n!DONE${ColorsText.reset}\n");
  }
}
