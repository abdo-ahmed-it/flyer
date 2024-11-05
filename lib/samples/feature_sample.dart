

import '../core/app_helper.dart';
import '../core/extensions.dart';

String featureSample(String featureName) {
  return '''
  import 'package:app_features/app_features.dart';
  import 'bloc/${featureName}_bloc.dart';
  import '../../config/app_config.dart';
  import '${featureName}_page.dart';

  
  class ${AppHelper.toClassName(featureName)}Feature extends Feature {
  
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => ${AppHelper.toClassName(featureName)}Bloc()),
      };
    @override
    String get name => '/$featureName';
  
    @override
    List<GoRoute> get routes => [
          GoRoute(path: name, name: name, builder: (_, state) => const ${AppHelper.toClassName(featureName)}Page())
        ];
  }
  ''';
}