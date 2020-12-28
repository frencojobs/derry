import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:derry/commands.dart';
import 'package:derry/error.dart';
import 'package:derry/models.dart';
import 'package:derry/version.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await executeDerry(arguments);
  exit(exitCode);
}

Future<int> executeDerry(List<String> arguments) async {
  final runner = CommandRunner('derry', 'A script runner/manager for dart.');

  runner
    ..addCommand(RunCommmand())
    ..addCommand(ListCommand())
    ..addCommand(UpgradeCommand())
    ..addCommand(SourceCommand())
    ..argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'output the version number',
    );

  final argResults = runner.parse(arguments);

  if (argResults['version'] as bool) {
    stdout.writeln('derry version: $packageVersion');
    return 0;
  } else {
    try {
      final exitCode = await runner.run(arguments);
      return exitCode as int ?? 0;
    } on DerryError catch (error) {
      errorHandler(error);
      return 1;
    } catch (error) {
      if (error is UsageException &&
          error.message.startsWith('Could not find a command named')) {
        final exitCode = executeDerry(['run', ...arguments]);
        return exitCode;
      } else {
        stderr.writeln(error);
        return 1;
      }
    }
  }
}
