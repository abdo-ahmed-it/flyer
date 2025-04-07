import 'package:flyer/samples/action_sample.dart';

String generateAction({
  required String name,
  required String method,
  required String path,
  ContentDataType? dataType,
  required bool isAuth,
  Map<String, dynamic>? data,
}) {
  return actionSample(
      name: name,
      method: method,
      path: path,
      data: data,
      isAuth: isAuth,
      dataType: dataType);
}

enum ContentDataType { formData, bodyData }
