import 'dart:io';
import 'package:app_creator/samples/extensions.dart';

import '../samples/page_sample.dart';
import 'creator_util.dart';



void main() async {
  stdout.write("Enter Your Name Feature : ");
  String? featureName = stdin.readLineSync();
  stdout.write("Enter Your Name Route : ");
  String? routeName = stdin.readLineSync();
  var path = '${Directory.current.path}/lib';
  String content = await CreatorUtil.readFileContent(
      '$path/features/$featureName/${featureName}_feature.dart');
  // Find the position of the opening and closing brackets
  int startIndex = content.indexOf('[');
  int endIndex = content.indexOf(']');

  // Extract the content between the brackets
  if (startIndex != -1 && endIndex != -1) {
    CreatorUtil.createDirectory('$path/features/$featureName/pages');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/pages/${routeName}_page.dart',
        pageSample(routeName ?? ''));
    List<String> oldRoutes =
        content.substring(startIndex + 1, endIndex).split(',');

    String routeAdded =
        '''GoRoute(path: '/$routeName', name:  '/$routeName', builder: (_, state) => const ${routeName?.toCapitalized}Page())''';
    List<String> routes = [];
    routes.addAll(oldRoutes);
    routes.add(routeAdded);
    content = content.replaceRange(
      startIndex,
      endIndex + 1,
      routes.toString(),
    );
    content =
        '''import 'pages/${routeName}_page.dart';\n
$content''';
    CreatorUtil.editFileContent(
        '$path/features/$featureName/${featureName}_feature.dart', content);
  } else {
    print('No brackets found');
  }
}
