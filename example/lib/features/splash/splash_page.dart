import 'package:app_features/app_features.dart';
import 'package:flutter/material.dart';
import '../../core/utils/api_util.dart';

import '../home/home_feature.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApiUtils.init(context);
    });

    Future.delayed(const Duration(seconds: 3), () {
      AppFeatures.get<HomeFeature>().go();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}
