import 'dart:io' show stdout;

import 'package:args/command_runner.dart';
import 'package:derry/src/utils/pubspec.dart';
import 'package:derry/src/utils/scripts_registry.dart';
import 'package:tint/tint.dart';

/// The `derry run` command
/// which parses the arguments and execute the scripts in
/// the executor using ffi.
///
/// Note:
///
/// - the package name, version, and the script will also be
/// printed out as the info message
class RunCommmand extends Command {
  @override
  String get name => 'run';

  @override
  String get description => 'find the script definition and execute it';

  Map<String, dynamic> _parseExtras(List<String> args) {
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
  Future<int> run() async {
    final argResults = super.argResults!;

    final parsed = _parseExtras(argResults.arguments);
    final args = super.argParser.parse(parsed['args'] as Iterable<String>).rest;
    final extra = (parsed['extra'] as List).join(' ');

    if (args.isEmpty) {
      stdout.writeln(super.usage);
      return 0;
    } else {
      final arg = args.join(' ').trim();

      final pubspec = Pubspec();
      final info = await pubspec.getInfo();
      final scripts = await pubspec.getScripts();

      final registry = ScriptsRegistry(scripts);

      stdout.writeln('> $info $arg'.bold());
      return registry.runScript(arg, extra: extra);
    }
  }
}
