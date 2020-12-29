import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:console/console.dart';

import 'package:derry/helpers.dart';

/// The `derry ls` command
/// which will print a recursive tree representation of
/// all the available scripts within the current config.
///
/// Notes:
///
/// - the name & version of the package by the config will also be printed out
/// - subcommands will starts with an `$` and will have a different color
class ListCommand extends Command {
  @override
  String get name => 'ls';

  @override
  String get description => 'list available scripts in the current config';

  @override
  Future<void> run() async {
    final info = await loadInfo();
    final infoLine = '+ ${info.name}@${info.version}';
    final definitions = await loadDefinitions();
    final keys = makeKeys(definitions)..sort();

    final mapping = Map.fromEntries(
      keys
          .asMap()
          .entries
          .map(
            (entry) => MapEntry(
              entry.key,
              parseDefinition(search(definitions, entry.value)),
            ),
          )
          .map(
            (entry) => MapEntry(
              entry.key,
              entry.value.scripts.where((s) => s.startsWith('\$')).toList(),
            ),
          ),
    );

    stdout.writeln(infoLine);
    stdout.writeln('│');

    for (final entry in keys.asMap().entries) {
      final i = entry.key;
      final value = entry.value;
      final subcommands = mapping[entry.key];

      stdout.writeln('${_getPrefix(i, keys.length)} $value');

      for (final subEntry in subcommands.asMap().entries) {
        final j = subEntry.key;
        final subValue = format(
          '{color.green}'
          '${subEntry.value.replaceAll('\\\$', '\$').split(':').join(' ')}'
          '{color.end}',
        );

        stdout.writeln(
          '${i == keys.length - 1 ? ' ' : '│'}'
          '   '
          '${_getPrefix(j, subcommands.length)} $subValue',
        );
      }
    }
  }

  String _getPrefix(int current, int len) {
    return current == len - 1 ? '└──' : '├──';
  }
}
