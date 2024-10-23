import 'package:example/core/app_extinsions.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _item(
          title: context.loc.hello_title,
          label: context.loc.label_text,
          hint: context.loc.hint_text,
          textLabel: context.loc.text_label_text),
    );
  }
}

_item({required String title, label, textLabel, hint}) {
  return Column(
    children: [Text(title), Text(context.loc.hello_text), Text(context.loc.hello_text)],
  );
}
