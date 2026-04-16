String onboardingFeatureSample() {
  return '''
import 'package:app_features/app_features.dart';
import 'onboarding_page.dart';

class OnBoardingFeature extends Feature {

  static OnBoardingFeature get to => AppFeatures.get();

  @override
  String get name => '/onboarding';

  @override
  List<GoRoute> get routes => [
    GoRoute(path: name, name: name, builder: (_, state) => const OnboardingPage()),
  ];
}
''';
}
