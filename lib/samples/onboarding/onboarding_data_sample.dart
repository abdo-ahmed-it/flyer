String onboardingDataSample() {
  return '''
import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Welcome',
      description: 'Discover all the features of our app and enjoy a seamless experience.',
      icon: Icons.waving_hand,
    ),
    OnboardingModel(
      title: 'Easy to Use',
      description: 'Simple and intuitive interface designed for the best user experience.',
      icon: Icons.touch_app,
    ),
    OnboardingModel(
      title: 'Get Started',
      description: 'Create your account and start exploring all the possibilities.',
      icon: Icons.rocket_launch,
    ),
  ];
}
''';
}
