import 'package:args/command_runner.dart';

class InstallCommand extends Command {
  InstallCommand() {
    // argParser.addMultiOption(
    //   'install',
    //   help: 'install packages',
    //   // defaultsTo: ['en'],
    // );
  }

  @override
  String get description => 'Install packages';

  @override
  String get name => 'install';

  @override
  void run() async {
    if (argResults != null) {
      List<String> package = argResults!['package'];
    }
    // print(
    //     '${ColorsText.green}Infra Structure created successfully${ColorsText.reset}');
  }

  void installPackages(List<String> packages) async {
    for (var package in packages) {}
  }
}
