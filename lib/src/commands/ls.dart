import 'dart:io' show stdout;

import 'package:args/command_runner.dart';
import 'package:derry/utils.dart';
import 'package:tint/tint.dart';

/// Returns length of the longest string in a list.
int _getLongestStringLength(List<String> strings) {
  final sortedList = strings.map((str) => str.length).toList()..sort();
  return sortedList.last;
}

/// Returns the path prefix to display in a tree.
String _getPrefix(int current, int len) {
  return current == len - 1 ? '└──' : '├──';
}

/// The `derry ls` command
/// which will print a recursive tree representation of
/// all the available scripts within the current config.
///
/// Notes:
///
/// - the name & version of the package by the config will also be printed out
/// - references will starts with an `$` and will have a different color
class ListCommand extends Command {
  ListCommand() {
    super.argParser.addFlag(
          'description',
          abbr: 'd',
          help: 'whether to show descriptions or not',
          negatable: false,
        );
  }

  @override
  String get name => 'ls';

  @override
  String get description => 'list available scripts in the current config';

  @override
  Future<void> run() async {
    final argResults = super.argResults!;
    final showDescriptions = argResults['description'] as bool;

    final pubspec = Pubspec();
    final info = await pubspec.getInfo();
    final scripts = await pubspec.getScripts();

    final registry = ScriptsRegistry(scripts);
    final paths = registry.getPaths()..sort();

    final definitions =
        paths.map((path) => registry.getDefinition(path)).toList();
    final descriptions = definitions.map((def) => def.description).toList();
    final references = definitions
        .map((def) =>
            def.scripts.where((s) => s.startsWith(referencePrefix)).toList())
        .toList();

    final buffer = StringBuffer();

    buffer.writeln('+ $info');
    buffer.writeln('│');

    final longestScriptLength = _getLongestStringLength(paths);

    for (final pathEntry in paths.asMap().entries) {
      final pathIndex = pathEntry.key;
      final path = pathEntry.value;

      final description = descriptions[pathIndex];
      final refs = references[pathIndex];

      final formattedDescription = showDescriptions && description != null
          ? '${''.padLeft(longestScriptLength + 4 - path.length)} - $description'
              .gray()
          : '';

      buffer.writeln(
          '${_getPrefix(pathIndex, paths.length)} $path $formattedDescription');

      for (final refEntry in refs.asMap().entries) {
        final referenceIndex = refEntry.key;
        final reference = refEntry.value;

        final formattedReference = reference
            .replaceAll('\\$referencePrefix', referencePrefix)
            .split(referenceNestingDelimiter)
            .join(' ')
            .green();

        buffer.writeln(
          '${pathIndex == paths.length - 1 ? ' ' : '│'}'
          '   '
          '${_getPrefix(referenceIndex, refs.length)} $formattedReference',
        );
      }
    }

    stdout.writeln(buffer.toString());
  }
}
