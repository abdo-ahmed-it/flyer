
import 'extensions.dart';

String stateSample(String featureName) {
  return '''
  import 'package:equatable/equatable.dart';
  
  class ${featureName.toCapitalized}State extends Equatable {
   const ${featureName.toCapitalized}State();
  
    ${featureName.toCapitalized}State copyWith() => ${featureName.toCapitalized}State();
  
    @override
    List<Object?> get props => [];
  }
  ''';
}