import 'package:flyer/jsonToDart/model_generator.dart';

String generateResponse(String json, String className) {
  ModelGenerator model = ModelGenerator('${className}Response');

  DartCode code = model.generateDartClasses(json.toString());
  return code.code;
}
