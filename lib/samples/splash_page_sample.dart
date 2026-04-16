String splashPageSample({bool onboarding = false}) {
  String onboardingImport = onboarding
      ? "import '../on_boarding/on_boarding_feature.dart';\nimport '../../config/app_config.dart';\nimport '../../core/app_storage.dart';\n"
      : '';
  String navigateLogic = onboarding
      ? '''
      if (getIt.get<AppStorage>().getShowOnboarding()) {
        OnBoardingFeature.to.go();
      } else {
        AppFeature.to.go();
      }'''
      : '      AppFeature.to.go();';

  return '''
import 'package:flutter/material.dart';
import '../../core/utils/api_util.dart';
import '../../app/app_feature.dart';
$onboardingImport

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
$navigateLogic
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

  ''';
}
