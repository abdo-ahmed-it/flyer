
import '../core/app_helper.dart';
import '../core/extensions.dart';

String cubitSample(String featureName) {
  return '''
 import 'package:flutter_bloc/flutter_bloc.dart';
 
 import '${featureName}_state.dart';

  class ${AppHelper.toClassName(featureName)}Bloc extends Cubit<${AppHelper.toClassName(featureName)}State>{
  ${AppHelper.toClassName(featureName)}Bloc(): super(const ${AppHelper.toClassName(featureName)}State());
  }
  ''';
}