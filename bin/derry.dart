import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:derry/commands.dart';
import 'package:derry/error.dart';
import 'package:derry/version.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await runDerry(arguments);
  exit(exitCode);
}

Future<int> runDerry(List<String> arguments) async {
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
      return exitCode as int? ?? 0;
      // ignore: avoid_catching_errors
    } on DerryError catch (error) {
      handleError(error);
      return 1;
    } catch (exception) {
      if (exception is UsageException && exception.message.startsWith('Could not find a command named')) {
        final exitCode = runDerry(['run', ...arguments]);
        return exitCode;
      } else {
        stderr.writeln(exception);
        return 1;
      }
    }
  }
}
