import 'dart:io';

import 'creator_util.dart';


void main() async {
  var path = '${Directory.current.path}/lib';

  stdout.write("Enter Your App Languages as Like This ar,en,... : ");
  List<String> languages = stdin.readLineSync()?.split(',')??['ar'];

  String content = await CreatorUtil.readFileContent(
      '${Directory.current.path}/pubspec.yaml');
  content= content.replaceFirst('dependencies:', '''dependencies:\n  flutter_localizations:
    sdk: flutter''');
  CreatorUtil.editFileContent(
      '${Directory.current.path}/pubspec.yaml', '$content  generate: true');
  CreatorUtil.createDirectory('$path/l10n');
  for(String code in languages){
    CreatorUtil.createFileWithContent('$path/l10n/app_$code.arb','{"home":"$code"}');
  }
  CreatorUtil.createFileWithContent('${Directory.current.path}/l10n.yaml', '''
arb-dir: lib/l10n
template-arb-file: app_ar.arb
output-localization-file: app_localizations.dart
  ''');
}
