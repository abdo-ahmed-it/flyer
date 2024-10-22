import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _item(title: ' Hello title'),
    );
  }
}

_item({required String title}) {
  return Column(
    children: [
      Text(title),
      Text('Hello Text')
    ],
  );
}
