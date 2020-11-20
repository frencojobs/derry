// Dart imports:
import 'dart:io';

// Package imports:
import 'package:args/command_runner.dart';

// Project imports:
import 'package:derry/commands.dart';
import 'package:derry/error.dart';
import 'package:derry/models.dart';
import 'package:derry/version.dart';

Future<void> main(List<String> arguments) async {
  await executeDerry(arguments);
}

Future<void> executeDerry(List<String> arguments) async {
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
  } else {
    try {
      await runner.run(arguments);
    } on DerryError catch (error) {
      errorHandler(error);
    } catch (error) {
      if (error is UsageException &&
          error.message.startsWith('Could not find a command named')) {
        await executeDerry(['run', ...arguments]);
      } else {
        stderr.writeln(error);
        exit(1);
      }
    }
  }
}
