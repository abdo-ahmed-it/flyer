import '../core/app_helper.dart';

String cubitSample(String featureName) {
  return '''
 import 'package:flutter_bloc/flutter_bloc.dart';
 import '../../../config/app_config.dart';

 import '${featureName}_state.dart';

  class ${AppHelper.toClassName(featureName)}Bloc extends Cubit<${AppHelper.toClassName(featureName)}State>{

  static ${AppHelper.toClassName(featureName)}Bloc get to => getIt.get();

  ${AppHelper.toClassName(featureName)}Bloc(): super(const ${AppHelper.toClassName(featureName)}State());
  }
  ''';
}
