import 'package:http/http.dart' as http;

Future<String?> fetchResponse({
  required String url,
  required String method,
  String? token,
  required String locale,
  dynamic body,
}) async {
  var headers = {
    'Accept': 'application/json',
    'Accept-Language': locale,
  };
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }

  print('start fetch url $url method $method body $body'); // للتصحيح

  try {
    if (method == 'GET') {
      print('start Get Fetching $url');
      var response = await http.get(Uri.parse(url), headers: headers);
      print('response finish ${response.body}');
      if (response.statusCode == 200) return response.body;
    } else if (method == 'POST') {
      Map<String, String> formData = {};
      if (body != null && body['mode'] == 'formdata') {
        for (var field in body['formdata']) {
          if (field['type'] == 'text') {
            formData[field['key']] = field['value'];
          }
          // تجاهل الحقول من نوع file لو مفيهاش src صالح
        }
      }
      print('start Post Fetching $url with body $formData');
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: formData.isNotEmpty ? formData : null,
      );
      print('response finish ${response.body}');
      if (response.statusCode == 200) return response.body;
    }
    // print('Failed to fetch $url: ${response.statusCode}');
    return null;
  } catch (e) {
    print('Error fetching $url: $e');
    return null;
  }
}