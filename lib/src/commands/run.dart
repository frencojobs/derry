// Dart imports:
import 'dart:io';

// Package imports:
import 'package:args/command_runner.dart';

// Project imports:
import 'package:derry/helpers.dart';
import 'package:derry/src/execute.dart';

/// the `derry run` command
/// which parses the arguments and execute the scripts in
/// the executor using ffi. It takes `--silent` or `-s` as
/// a flag to decide whether to print output or not, which
/// will be `false` by default.
///
/// Note:
///
/// - the package name, version, and the script will also be
/// printed out as the info message
class RunCommmand extends Command {
  bool get alias => false;

  @override
  String get name => 'run';

  @override
  String get description => 'find the script definition and execute it';

  RunCommmand() {
    super.argParser.addFlag(
          'silent',
          abbr: 's',
          help: 'determine whether to show outputs or not',
          negatable: false,
        );
  }

  Map<String, dynamic> parseExtras(List<String> args) {
    final flag = args.contains('--');

    if (flag) {
      final start = args.indexOf('--');
      return <String, List>{
        'args': args.sublist(0, start).toList(),
        'extra': args.sublist(start + 1).toList(),
      };
    } else {
      return <String, List>{
        'args': args,
        'extra': [],
      };
    }
  }

  @override
  Future<void> run() async {
    final parsed = parseExtras(super.argResults.arguments);
    final args = super.argParser.parse(parsed['args'] as Iterable<String>).rest;
    final extra = (parsed['extra'] as List).join(' ');
    final silent = super.argResults['silent'] as bool;

    if (args.isEmpty && !alias) {
      stdout.writeln(super.usage);
    } else {
      final arg =
          alias ? '$name ${args.join(' ')}'.trim() : args.join(' ').trim();

      final info = await loadInfo();
      final definitions = await loadDefinitions();
      final infoLine = '> ${info.name}@${info.version} $arg';

      execute(
        definitions,
        arg,
        extra: extra,
        silent: silent,
        infoLine: infoLine,
      );
    }
  }
}
