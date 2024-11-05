import 'dart:io';

import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/creatores.dart';
import 'package:app_creator/functions/extract_strings.dart';
import 'package:app_creator/functions/fiend_unused_package.dart';
import 'package:app_creator/functions/fined_unused_assets.dart';
import 'package:app_creator/functions/fined_unused_file.dart';
import 'package:app_creator/functions/formate_code.dart';
import 'package:app_creator/functions/generate_dart_class_from_json.dart';

void main() async {
  stdout.write("${ColorsText.blue}Select an option:${ColorsText.reset}\n");
  stdout.write("${ColorsText.green}1. Create Infra Structure\n");
  stdout.write("${ColorsText.green}2. Create Feature\n");
  stdout.write("${ColorsText.green}3. Add Page in Feature\n");
  stdout.write("${ColorsText.green}4. Add form in Feature \n");
  stdout.write("${ColorsText.green}5. Fiend Unused Package \n");
  stdout.write("${ColorsText.green}6. Fiend Unused File \n");
  stdout.write("${ColorsText.green}7. Fiend Unused Assets File \n");
  stdout.write("${ColorsText.green}8. Fiend Text In Text Widget\n");
  stdout.write("${ColorsText.green}9. Fiend Arabic Text \n");
  stdout.write("${ColorsText.green}10. Create Model Class From Json\n");
  stdout.write("${ColorsText.green}11. Init App Language \n");
  stdout.write("${ColorsText.green}12. Format Dart Code ${ColorsText.reset}\n");

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
    case '7':
      fiendUnusedAssets();
      break;
    case '8':
      extractTextFromTextWidgets();
      break;
    case '9':
      extractArabicText();
      break;
    case '10':
      generateModelClassFromJson();
    case '11':
      Creators.addLang();
    case '12':
      formatCode();
      break;

    default:
      stdout.write(
          "${ColorsText.red}Invalid selection.\n!DONE${ColorsText.reset}\n");
  }
}
