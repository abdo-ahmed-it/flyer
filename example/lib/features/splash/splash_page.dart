import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _item(
          title: ' Hello title',
          label: 'Label Text',
          hint: 'hint Text',
          textLabel: 'Text Label text'),
    );
  }
}

_item({required String title, label, textLabel, hint}) {
  return Column(
    children: [Text(title), Text('Hello Text'), Text('Hello Text')],
  );
}
