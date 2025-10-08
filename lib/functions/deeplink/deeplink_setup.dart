import 'dart:io';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/creator_util.dart';
import 'package:flyer/functions/deeplink/extract_project_info.dart';
import 'package:flyer/functions/install_package.dart';
import 'package:flyer/samples/deeplink_samples.dart';

Future<void> setupDeeplink({
  String? domain,
  String? scheme,
  required bool isDryRun,
}) async {
  print(
      '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
  print(
      '${ColorsText.cyan}          Deep Linking Setup ${isDryRun ? '(DRY RUN)' : ''}${ColorsText.reset}');
  print(
      '${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');

  // Extract project information
  final projectInfo = await extractProjectInfo();

  // Display extracted information
  print('${ColorsText.blue}🔍 Extracted Information:${ColorsText.reset}');
  if (projectInfo.androidPackageName != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} Android Package: ${projectInfo.androidPackageName}');
  }
  if (projectInfo.iosBundleId != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} iOS Bundle ID: ${projectInfo.iosBundleId}');
  }
  if (projectInfo.iosTeamId != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} iOS Team ID: ${projectInfo.iosTeamId}');
  } else {
    print(
        '  ${ColorsText.yellow}⚠${ColorsText.reset} iOS Team ID: Not found in project');
  }
  if (projectInfo.debugSha256 != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} Debug SHA256: ${projectInfo.debugSha256}');
  } else {
    print(
        '  ${ColorsText.yellow}⚠${ColorsText.reset} Debug SHA256: Not found (keytool not available or keystore not found)');
  }
  print('');

  // Display configuration
  print('${ColorsText.blue}⚙️  Configuration:${ColorsText.reset}');
  if (domain != null) {
    print('  • Domain: $domain');
  }
  if (scheme != null) {
    print('  • Custom Scheme: $scheme://');
  }
  print('');

  // Plan what will be done
  print(
      '${ColorsText.blue}📝 Files to be created/modified:${ColorsText.reset}\n');

  final List<String> fileChanges = [];

  // Android changes
  if (domain != null || scheme != null) {
    fileChanges.add(
        '  1. ${ColorsText.cyan}android/app/src/main/AndroidManifest.xml${ColorsText.reset}');
    final intentDetails = <String>[];
    if (domain != null) intentDetails.add('https://$domain');
    if (scheme != null) intentDetails.add('$scheme://');
    fileChanges
        .add('     └─ Add intent-filter for: ${intentDetails.join(', ')}');
  }

  if (domain != null && projectInfo.androidPackageName != null) {
    fileChanges.add('');
    fileChanges.add(
        '  2. ${ColorsText.cyan}android/.well-known/assetlinks.json${ColorsText.reset}');
    fileChanges.add('     └─ New file with package & SHA256 fingerprint');
  }

  // iOS changes
  if (domain != null && projectInfo.iosBundleId != null) {
    fileChanges.add('');
    fileChanges.add(
        '  3. ${ColorsText.cyan}ios/.well-known/apple-app-site-association${ColorsText.reset}');
    fileChanges.add('     └─ New file with Team ID & Bundle ID');
  }

  if (scheme != null) {
    fileChanges.add('');
    fileChanges
        .add('  4. ${ColorsText.cyan}ios/Runner/Info.plist${ColorsText.reset}');
    fileChanges.add('     └─ Add CFBundleURLSchemes for: $scheme');
  }

  // Code changes
  fileChanges.add('');
  fileChanges.add(
      '  5. ${ColorsText.cyan}lib/core/utils/deeplink_handler.dart${ColorsText.reset}');
  fileChanges.add('     └─ New utility class for handling deep links');

  fileChanges.add('');
  fileChanges.add('  6. ${ColorsText.cyan}lib/main.dart${ColorsText.reset}');
  fileChanges.add('     └─ Add DeeplinkHandler initialization');

  for (final change in fileChanges) {
    print(change);
  }

  // Manual steps
  print('\n${ColorsText.yellow}⚠️  Manual Steps Required:${ColorsText.reset}');
  if (domain != null) {
    print('  • iOS: Add Associated Domains capability in Xcode');
    print('    └─ Add: applinks:$domain');
    print('  • Upload .well-known files to https://$domain/');
  }
  if (projectInfo.iosTeamId == null && domain != null) {
    print('  • iOS: Add your Team ID to apple-app-site-association file');
  }
  if (projectInfo.debugSha256 == null && domain != null) {
    print('  • Android: Add SHA256 fingerprint to assetlinks.json');
  }

  if (isDryRun) {
    print(
        '\n${ColorsText.cyan}ℹ️  This was a dry run. No changes were made.${ColorsText.reset}');
    print(
        '${ColorsText.cyan}   Run without --dry-run to apply changes.${ColorsText.reset}');
    return;
  }

  // Ask for confirmation
  print('\n${ColorsText.green}Continue with setup? (y/n):${ColorsText.reset} ');
  final answer = stdin.readLineSync()?.toLowerCase();

  if (answer != 'y' && answer != 'yes') {
    print('${ColorsText.yellow}Setup cancelled.${ColorsText.reset}');
    return;
  }

  print('\n${ColorsText.blue}🚀 Starting setup...${ColorsText.reset}\n');

  // Install app_links package
  print(
      '${ColorsText.blue}📦 Installing app_links package...${ColorsText.reset}');
  await installPackage('app_links');
  print('');

  // 1. Update AndroidManifest.xml
  if (domain != null || scheme != null) {
    await _updateAndroidManifest(domain: domain, scheme: scheme);
  }

  // 2. Create assetlinks.json
  if (domain != null && projectInfo.androidPackageName != null) {
    await _createAssetLinks(
      packageName: projectInfo.androidPackageName!,
      sha256: projectInfo.debugSha256,
    );
  }

  // 3. Create apple-app-site-association
  if (domain != null && projectInfo.iosBundleId != null) {
    await _createAppleAppSiteAssociation(
      teamId: projectInfo.iosTeamId,
      bundleId: projectInfo.iosBundleId!,
    );
  }

  // 4. Update Info.plist
  if (scheme != null) {
    await _updateInfoPlist(scheme: scheme);
  }

  // 5. Create deeplink_handler.dart
  await _createDeeplinkHandler();

  // 6. Show integration instructions
  _showCompletionInstructions(
    domain: domain,
    scheme: scheme,
    projectInfo: projectInfo,
  );
}

Future<void> _updateAndroidManifest({String? domain, String? scheme}) async {
  print(
      '${ColorsText.blue}📱 Updating AndroidManifest.xml...${ColorsText.reset}');

  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (!manifestFile.existsSync()) {
    print(
        '${ColorsText.red}Error: AndroidManifest.xml not found${ColorsText.reset}');
    return;
  }

  String content = await manifestFile.readAsString();

  // Check if intent filters already exist
  if (content.contains('android.intent.action.VIEW') &&
      content.contains('android.intent.category.BROWSABLE')) {
    print(
        '${ColorsText.yellow}  ⚠ Intent filters already exist in AndroidManifest.xml${ColorsText.reset}');
    print(
        '${ColorsText.yellow}    Please add them manually if needed${ColorsText.reset}');
    return;
  }

  final intentFilter = androidManifestIntentFilterSample(
    domain: domain ?? '',
    scheme: scheme,
  );

  // Find the activity closing tag and add intent filters before it
  final activityEndRegex = RegExp(r'</activity>');
  final match = activityEndRegex.firstMatch(content);

  if (match != null) {
    final insertPosition = match.start;
    content = content.substring(0, insertPosition) +
        intentFilter +
        '\n        ' +
        content.substring(insertPosition);

    await manifestFile.writeAsString(content);
    print(
        '${ColorsText.green}  ✓ AndroidManifest.xml updated${ColorsText.reset}');
  } else {
    print(
        '${ColorsText.red}  ✗ Could not find </activity> tag in AndroidManifest.xml${ColorsText.reset}');
  }
}

Future<void> _createAssetLinks({
  required String packageName,
  String? sha256,
}) async {
  print('${ColorsText.blue}📄 Creating assetlinks.json...${ColorsText.reset}');

  final wellKnownDir = Directory('android/.well-known');
  if (!wellKnownDir.existsSync()) {
    wellKnownDir.createSync(recursive: true);
  }

  final content = assetLinksJsonSample(
    packageName: packageName,
    sha256Fingerprint: sha256 ?? 'YOUR_SHA256_FINGERPRINT_HERE',
  );

  CreatorUtil.createFileWithContent(
    'android/.well-known/assetlinks.json',
    content,
    canFormated: false,
  );

  if (sha256 == null) {
    print(
        '${ColorsText.yellow}  ⚠ Remember to replace YOUR_SHA256_FINGERPRINT_HERE with your actual SHA256${ColorsText.reset}');
  }
}

Future<void> _createAppleAppSiteAssociation({
  String? teamId,
  required String bundleId,
}) async {
  print(
      '${ColorsText.blue}📄 Creating apple-app-site-association...${ColorsText.reset}');

  final wellKnownDir = Directory('ios/.well-known');
  if (!wellKnownDir.existsSync()) {
    wellKnownDir.createSync(recursive: true);
  }

  final content = appleAppSiteAssociationSample(
    teamId: teamId ?? 'YOUR_TEAM_ID_HERE',
    bundleId: bundleId,
  );

  CreatorUtil.createFileWithContent(
    'ios/.well-known/apple-app-site-association',
    content,
    canFormated: false,
  );

  if (teamId == null) {
    print(
        '${ColorsText.yellow}  ⚠ Remember to replace YOUR_TEAM_ID_HERE with your actual Team ID${ColorsText.reset}');
  }
}

Future<void> _updateInfoPlist({required String scheme}) async {
  print('${ColorsText.blue}🍎 Updating Info.plist...${ColorsText.reset}');

  final infoPlistFile = File('ios/Runner/Info.plist');
  if (!infoPlistFile.existsSync()) {
    print('${ColorsText.red}Error: Info.plist not found${ColorsText.reset}');
    return;
  }

  String content = await infoPlistFile.readAsString();

  // Check if CFBundleURLTypes already exists
  if (content.contains('CFBundleURLTypes')) {
    print(
        '${ColorsText.yellow}  ⚠ CFBundleURLTypes already exists in Info.plist${ColorsText.reset}');
    print(
        '${ColorsText.yellow}    Please add the scheme manually if needed${ColorsText.reset}');
    return;
  }

  final urlSchemes = infoPlistUrlSchemesSample(scheme: scheme);

  // Find </dict> before </plist> and add URL schemes
  final dictEndRegex = RegExp(r'</dict>\s*</plist>');
  final match = dictEndRegex.firstMatch(content);

  if (match != null) {
    final insertPosition = match.start;
    content = content.substring(0, insertPosition) +
        urlSchemes +
        '\n' +
        content.substring(insertPosition);

    await infoPlistFile.writeAsString(content);
    print('${ColorsText.green}  ✓ Info.plist updated${ColorsText.reset}');
  } else {
    print(
        '${ColorsText.red}  ✗ Could not find </dict></plist> in Info.plist${ColorsText.reset}');
  }
}

Future<void> _createDeeplinkHandler() async {
  print(
      '${ColorsText.blue}🔧 Creating deeplink_handler.dart...${ColorsText.reset}');

  // Ensure the directory exists
  CreatorUtil.createDirectory('lib/core/utils');

  CreatorUtil.createFileWithContent(
    'lib/core/utils/deeplink_handler.dart',
    deeplinkHandlerSample(),
  );
}

void _showCompletionInstructions(
    {String? domain, String? scheme, required ProjectInfo projectInfo}) {
  print(
      '\n${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}');
  print(
      '${ColorsText.green}          ✅ Deep linking setup completed!${ColorsText.reset}');
  print(
      '${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');

  print('${ColorsText.blue}📱 Android Configuration:${ColorsText.reset}');
  print(
      '  ${ColorsText.green}✓${ColorsText.reset} AndroidManifest.xml updated');
  if (domain != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} assetlinks.json generated at: ${ColorsText.cyan}android/.well-known/assetlinks.json${ColorsText.reset}');
  }

  print('\n${ColorsText.blue}🍎 iOS Configuration:${ColorsText.reset}');
  if (scheme != null) {
    print('  ${ColorsText.green}✓${ColorsText.reset} Info.plist updated');
  }
  if (domain != null) {
    print(
        '  ${ColorsText.green}✓${ColorsText.reset} apple-app-site-association generated at: ${ColorsText.cyan}ios/.well-known/apple-app-site-association${ColorsText.reset}');
  }

  print('\n${ColorsText.yellow}📤 Next Steps:${ColorsText.reset}\n');

  var stepNumber = 1;

  // Main.dart integration
  print(
      '  ${stepNumber}. ${ColorsText.cyan}Add to lib/main.dart:${ColorsText.reset}');
  print(
      '     Import: ${ColorsText.gray}import \'package:your_app/core/utils/deeplink_handler.dart\';${ColorsText.reset}');
  print('     In main() or initState():');
  print(
      '     ${ColorsText.gray}${mainDeeplinkIntegrationSample()}${ColorsText.reset}\n');
  stepNumber++;

  if (domain != null) {
    // Upload server files
    print(
        '  ${stepNumber}. ${ColorsText.cyan}Upload server files:${ColorsText.reset}');
    print(
        '     • ${ColorsText.gray}https://$domain/.well-known/assetlinks.json${ColorsText.reset}');
    print(
        '     • ${ColorsText.gray}https://$domain/.well-known/apple-app-site-association${ColorsText.reset}');
    print(
        '     ${ColorsText.yellow}Note: Files must be accessible without authentication${ColorsText.reset}\n');
    stepNumber++;

    // iOS Associated Domains
    print(
        '  ${stepNumber}. ${ColorsText.cyan}iOS: Add Associated Domains in Xcode:${ColorsText.reset}');
    print(
        '     • Open ${ColorsText.gray}ios/Runner.xcworkspace${ColorsText.reset}');
    print('     • Select Runner target → Signing & Capabilities');
    print('     • Click "+ Capability" → Associated Domains');
    print(
        '     • Add: ${ColorsText.gray}applinks:$domain${ColorsText.reset}\n');
    stepNumber++;
  }

  // Verification
  if (domain != null && projectInfo.androidPackageName != null) {
    print(
        '  ${stepNumber}. ${ColorsText.cyan}Verify Android App Links:${ColorsText.reset}');
    print(
        '     ${ColorsText.gray}adb shell pm get-app-links ${projectInfo.androidPackageName}${ColorsText.reset}\n');
    stepNumber++;
  }

  print('${ColorsText.blue}🧪 Testing:${ColorsText.reset}\n');
  if (domain != null) {
    print('  • ${ColorsText.cyan}Android App Link:${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}adb shell am start -a android.intent.action.VIEW -d "https://$domain/path"${ColorsText.reset}\n');
    print('  • ${ColorsText.cyan}iOS Universal Link:${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}Open link in Notes app or Safari${ColorsText.reset}\n');
  }
  if (scheme != null) {
    print('  • ${ColorsText.cyan}Custom Scheme:${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}Android: adb shell am start -a android.intent.action.VIEW -d "$scheme://path"${ColorsText.reset}');
    print(
        '    ${ColorsText.gray}iOS: Open in Safari or Notes app${ColorsText.reset}\n');
  }

  print(
      '${ColorsText.green}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');
}
