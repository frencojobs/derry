// Package imports:
import 'package:args/command_runner.dart';

// Project imports:
import 'package:derry/src/execute.dart';
import 'package:derry/version.dart';

/// the `derry upgrade` command
/// which will attempt to run the pub command to
/// upgrade the derry package itself.
///
/// It's an equivalent of executing the
/// `pub global activate derry` in the derry executor.
class UpgradeCommand extends Command {
  @override
  String get name => 'upgrade';

  @override
  String get description => 'upgrade to the latest version of derry itself';

  @override
  Future<void> run() async {
    {
      const infoLine = '> derry@$packageVersion upgrade';

      execute(
        {'upgrade': 'pub global activate derry'},
        'upgrade',
        infoLine: infoLine,
      );
    }
  }
}
