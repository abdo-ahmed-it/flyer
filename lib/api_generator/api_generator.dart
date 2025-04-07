import 'dart:convert';
import 'dart:io';
import 'package:flyer/api_generator/generate_action.dart';
import 'package:flyer/api_generator/generate_response.dart';
import 'fetch_response.dart';

void generateFromCollection(String collectionPath) async {
  String content = File(collectionPath).readAsStringSync();
  Map<String, dynamic> collection = jsonDecode(content);

  // Extract variables
  String baseUrl = collection['variable']
      .firstWhere((v) => v['key'] == 'url' && !v.containsKey('disabled'))['value'];
  String token = collection['variable']
      .firstWhere((v) => v['key'] == 'token')['value'];
  String locale = collection['variable']
      .firstWhere((v) => v['key'] == 'locale' && !v.containsKey('disabled'))['value'];

  // Create actions directory
  Directory('lib/actions').createSync(recursive: true);

  // Process items recursively
  void processItems(List<dynamic> items) async {
    for (var item in items) {
      if (item.containsKey('request')) {
        String endpointName = item['name'];
        var request = item['request'];
        String method = request['method'];
        String url = '$baseUrl/${request['url']['path'].join('/')}';
        List<dynamic> responses = item['response'];

        // Determine auth type
        String authType = 'No Auth'; // Default
        if (request.containsKey('auth') && request['auth'] != null) {
          if (request['auth']['type'] == 'bearer') {
            authType = 'Bearer';
          }
        }

        String? responseBody;
        if (responses.isNotEmpty) {
          responseBody = responses[0]['body'];
        } else {
          responseBody = await fetchResponse(
            url: url,
            method: method,
            token: authType == 'Bearer' ? token : null, // Pass token only if Bearer
            locale: locale,
            body: request['body'],
          );
        }

        if (responseBody != null) {
          Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          String modelName = endpointName.replaceAll(' ', '');
          String action = generateAction(
            name: modelName,
            method: method,
            path: url,
            isAuth: authType == 'Bearer', // Pass true if Bearer, false otherwise
            // authType: authType, // Pass the auth type
          );
          String responseCode = generateResponse(responseBody, modelName); // Your response generator

          // Combine action and response in one file
          String fileContent = '''
import 'package:http/http.dart' as http;
import 'dart:convert';

$action

$responseCode
''';
          File('lib/actions/${modelName.toLowerCase()}_action.dart')
              .writeAsStringSync(fileContent);
          print('Generated ${modelName}_action.dart from $endpointName');
        }
      } else if (item.containsKey('item')) {
        processItems(item['item']);
      }
    }
  }

  processItems(collection['item']);
}