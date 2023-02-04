import 'dart:io' show stdout;

import 'package:args/command_runner.dart';
import 'package:derry/utils.dart';
import 'package:derry/version.dart';
import 'package:tint/tint.dart';

/// The `derry upgrade` command
/// which will attempt to run the pub command to
/// upgrade the derry package itself.
///
/// It's an equivalent of executing the
/// `dart run pub global activate derry` by yourself.
class UpgradeCommand extends Command {
  @override
  String get name => 'upgrade';

  @override
  String get description => 'upgrade to the latest version of derry itself';

  @override
  Future<void> run() async {
    const info = Info(name: 'derry', version: packageVersion);
    final registry = ScriptsRegistry({
      'upgrade': 'dart run pub global activate derry',
    });

    stdout.writeln('> $info upgrade'.bold());
    registry.runScript('upgrade');
  }
}
