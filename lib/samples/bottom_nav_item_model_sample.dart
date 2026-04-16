String bottomNavItemModelSample() {
  return '''
import 'package:flutter/material.dart';

class BottomNavItemModel {
  final Widget page;
  final IconData icon;
  final String label;
  final int index;

  BottomNavItemModel({
    required this.page,
    required this.icon,
    required this.label,
    required this.index,
  });
}
''';
}
