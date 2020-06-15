part of derry;

/// the `derry ls` command
class ListCommand extends Command {
  @override
  String get name => 'ls';

  @override
  String get description =>
      'List the available scripts in the current directory.';

  @override
  Future<void> run() async {
    final info = await loadInfo();
    final infoLine = '+ ${info.name}@${info.version} ${info.pwd}';
    final definitions = await loadDefinitions();

    final mapping = Map.fromEntries(
      makeKeys(definitions)
          .asMap()
          .entries
          .map((entry) => MapEntry(
              entry.key, parseDefinition(search(definitions, entry.value))))
          .map(
            (entry) => MapEntry(
              entry.key,
              entry.value.scripts.where((s) => s.startsWith('\$')).toList(),
            ),
          ),
    );

    print(infoLine);
    print('│');
    for (final entry in makeKeys(definitions).asMap().entries) {
      final i = entry.key;
      final value = formatAlias(entry.value);
      final subcommands = mapping[entry.key];

      print('${getPrefix(i, makeKeys(definitions).length)} $value');

      for (final subEntry in subcommands.asMap().entries) {
        final j = subEntry.key;
        final subValue = format('{color.yellow}\${color.end}') +
            formatAlias(
              subEntry.value.replaceFirst('\$', '').replaceAll('\\\$', '\$'),
            );

        print('│   ${getPrefix(j, subcommands.length)} $subValue');
      }
    }
  }

  String formatAlias(String input) {
    return als.contains(input)
        ? format('{color.green}$input{color.end}')
        : input;
  }

  String getPrefix(int current, int len) {
    return current == len - 1 ? '└──' : '├──';
  }
}
