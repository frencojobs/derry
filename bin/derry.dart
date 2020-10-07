import 'dart:io' show stdout, stderr, exit;
import 'package:derry/derry.dart';
import 'package:args/command_runner.dart';

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
    } on Error catch (error) {
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
