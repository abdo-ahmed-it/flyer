String onboardingModelSample() {
  return '''
import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}
''';
}
