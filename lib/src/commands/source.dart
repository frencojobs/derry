import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:derry/helpers.dart';
import 'package:path/path.dart' as p;

/// The `derry source` command
/// which prints out the current config file location.
///
/// It will throw an error of [ErrorType.dnf] if config doesn't exist.
class SourceCommand extends Command {
  /// Constructs a `SourceCommand`.
  SourceCommand() {
    super.argParser.addFlag(
          'absolute',
          abbr: 'a',
          help: 'determine whether to show absolute paths or not',
          negatable: false,
        );
  }

  @override
  String get description => 'find the location of the derry config file';

  @override
  String get name => 'source';

  @override
  Future<void> run() async {
    final absolute = super.argResults['absolute'];

    if (absolute as bool) {
      stdout.writeln(p.normalize(File(await findSource()).absolute.path));
    } else {
      stdout.writeln(await findSource());
    }
  }
}
