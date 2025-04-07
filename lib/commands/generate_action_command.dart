import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flyer/api_generator/generate_action.dart';
import 'package:flyer/api_generator/generate_response.dart';
import 'package:flyer/api_generator/fetch_response.dart';
import 'package:flyer/core/colors_text.dart';

class GenerateActionsFromCollectionCommand extends Command {
  GenerateActionsFromCollectionCommand() {
    argParser.addOption('path',
        abbr: 'p',
        help: 'Path to the Postman collection JSON file',
        mandatory: true);
    argParser.addFlag('only-predefined',
        help: 'Generate actions only from predefined responses',
        defaultsTo: false);
  }

  @override
  String get description =>
      'Generate actions and responses from a Postman collection';

  @override
  String get name => 'actions-from-collection';

  @override
  void run() async {
    String collectionPath = argResults!['path'];
    bool onlyPredefined = argResults!['only-predefined'];

    File collectionFile = File(collectionPath);
    if (!collectionFile.existsSync()) {
      print(
          '${ColorsText.red}Error: Collection file not found at $collectionPath${ColorsText.reset}');
      exit(1);
    }

    print('Processing collection at $collectionPath...');
    String content = collectionFile.readAsStringSync();
    Map<String, dynamic> collection = jsonDecode(content);

    String baseUrl = collection['variable'].firstWhere(
        (v) => v['key'] == 'base_url' && !v.containsKey('disabled'),
        orElse: () =>
            {'key': 'base_url', 'value': 'https://default.api'})['value'];
    String token = collection['variable'].firstWhere((v) => v['key'] == 'token',
        orElse: () => {'key': 'token', 'value': ''})['value'];
    String locale = collection['variable'].firstWhere(
        (v) => v['key'] == 'locale' && !v.containsKey('disabled'),
        orElse: () => {'key': 'locale', 'value': 'en'})['value'];

    Directory('lib/actions').createSync(recursive: true);
    await processItems(
        collection['item'], baseUrl, token, locale, onlyPredefined);

    print(
        '${ColorsText.green}Actions generated successfully${ColorsText.reset}');
  }

  Future<void> processItems(List<dynamic> items, String baseUrl, String token,
      String locale, bool onlyPredefined) async {
    for (var item in items) {
      if (item.containsKey('request')) {
        String endpointName = item['name'];
        var request = item['request'];
        String method = request['method'];
        String url = '$baseUrl/${request['url']['path'].join('/')}';
        List<dynamic> responses = item['response'];

        String authType = 'No Auth';
        if (request.containsKey('auth') && request['auth'] != null) {
          if (request['auth']['type'] == 'bearer') authType = 'Bearer';
        }

        String? responseBody;
        if (responses.isNotEmpty) {
          responseBody = responses[0]['body'];
        } else if (!onlyPredefined) {
          responseBody = await fetchResponse(
            url: url,
            method: method,
            token: authType == 'Bearer' ? token : null,
            locale: locale,
            body: request['body'],
          );
        }

        if (responseBody != null) {
          try {
            print(
                'Raw responseBody before jsonDecode: $responseBody'); // للتصحيح
            Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
            String modelName = endpointName.replaceAll(' ', '');
            String action = generateAction(
              name: modelName,
              method: method,
              path: url,
              isAuth: authType == 'Bearer',
            );
            String responseCode = generateResponse(responseBody, modelName);

            String fileContent = '''

$action

$responseCode
''';
            File('lib/actions/${modelName.toLowerCase()}_action.dart')
                .writeAsStringSync(fileContent);
            print('Generated ${modelName}_action.dart from $endpointName');
          } catch (e) {
            print(
                '${ColorsText.red}Error parsing response for $endpointName: $e${ColorsText.reset}');
            print('Raw responseBody on error: $responseBody'); // للتصحيح
          }
        } else {
          print(
              '${ColorsText.yellow}Skipped $endpointName: No response available${ColorsText.reset}');
        }
      } else if (item.containsKey('item')) {
        await processItems(
            item['item'], baseUrl, token, locale, onlyPredefined);
      }
    }
  }
}
