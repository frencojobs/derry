import 'dart:io' show stdout;

import 'package:args/command_runner.dart';
import 'package:derry/utils.dart';
import 'package:path/path.dart' as path;

/// Gets the absolute path of a file.
String _getAbsolutePath(String filePath) =>
    path.normalize(path.absolute(filePath));

/// The `derry source` command
/// which prints out the current config file location.
class SourceCommand extends Command {
  SourceCommand() {
    super.argParser.addFlag(
          'absolute',
          abbr: 'a',
          help: 'determine whether to show absolute paths or not',
          negatable: false,
        );

    super.argParser.addFlag(
          'check',
          help:
              'determine whether to check if the config file exists and is valid or not',
          defaultsTo: true,
        );
  }

  @override
  String get name => 'source';

  @override
  String get description => 'find the location of the derry config file';

  @override
  Future<void> run() async {
    final argResults = super.argResults!;
    final check = argResults['check'] as bool;
    final absolute = argResults['absolute'] as bool;

    final pubspec = Pubspec();
    final source = await pubspec.getSource();

    if (check) await pubspec.getScripts();
    stdout.writeln(absolute ? _getAbsolutePath(source) : source);
  }
}
