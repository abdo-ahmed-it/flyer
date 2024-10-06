
import 'package:app_creator/core/extensions.dart';

String featureSample(String featureName) {
  return '''
  import 'package:app_features/app_features.dart';
  import 'bloc/${featureName}_bloc.dart';
  import '../../config/app_config.dart';
  import '${featureName}_page.dart';

  
  class ${featureName.toCapitalized}Feature extends Feature {
  
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => ${featureName.toCapitalized}Bloc()),
      };
    @override
    String get name => '/$featureName';
  
    @override
    List<GoRoute> get routes => [
          GoRoute(path: name, name: name, builder: (_, state) => const ${featureName.toCapitalized}Page())
        ];
  }
  ''';
}