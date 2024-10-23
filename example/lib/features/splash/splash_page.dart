import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _item(
          title: ' !Hello title&',
          label: 'Label Text',
          hint: '+hint Text',
          textLabel: '0767765'),
    );
  }
}

_item({required String title, label, textLabel, hint}) {
  return Column(
    children: [Text(title), Text('Hello Text $label'), Text('Hello Text')],
  );
}
