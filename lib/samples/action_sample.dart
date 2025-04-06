String actionSample({String? name,String?path,String? method}) {
  return '''
import 'package:api_request/api_request.dart';

class ${name}Action extends ApiRequestAction<${name}Response> {
  @override
  RequestMethod get method => RequestMethod.$method;

  @override
  String get path => '$path';

  @override
  ResponseBuilder<${name}Response> get responseBuilder =>
      (json) => ${name}Response.fromJson(json);
}


class ${name}Response {
  String? message;

  ${name}Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
  ''';
}
