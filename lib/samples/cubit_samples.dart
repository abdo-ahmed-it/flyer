
import 'package:app_creator/core/extensions.dart';

String cubitSample(String featureName) {
  return '''
 import 'package:flutter_bloc/flutter_bloc.dart';
 
 import '${featureName}_state.dart';

  class ${featureName.toCapitalized}Bloc extends Cubit<${featureName.toCapitalized}State>{
  ${featureName.toCapitalized}Bloc(): super(const ${featureName.toCapitalized}State());
  }
  ''';
}