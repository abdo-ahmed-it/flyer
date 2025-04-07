import 'package:flyer/api_generator/generate_action.dart';

String actionSample({
  required String name,
  required String path,
  required String method,
  Map<String, dynamic>? data,
  ContentDataType? dataType,
  bool isAuth = false,
}) {
  return '''
import 'package:api_request/api_request.dart';

class ${name}Action extends ApiRequestAction<${name}Response> {
  @override
  bool get authRequired => $isAuth;

  @override
  RequestMethod get method => RequestMethod.$method;

  @override
  String get path => '$path';

  @override
  Map<String, dynamic> get toMap => $data;

  @override
  ContentDataType? get contentDataType => $dataType;

  @override
  ResponseBuilder<${name}Response> get responseBuilder =>
      (json) => ${name}Response.fromJson(json);
}

  ''';
}
