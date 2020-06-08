part of derry;

/// the `derry run` command
class RunCommmand extends Command {
  @override
  String get name => 'run';

  @override
  String get description =>
      'Find the script definition from pubspec.yaml and execute it.';

  @override
  Future<void> run() async {
    final arguments = super.argResults.arguments;
    final scriptArguments =
        []; // arguments that come after -- are used while executing script

    if (arguments.contains('--')) {
      final index = arguments.indexOf('--');
      scriptArguments.addAll(arguments.sublist(index + 1));
    }

    if (arguments.isEmpty) {
      print(super.usage);
    } else {
      final info = await loadInfo();
      final definitions = await loadDefinitions();
      final name = info['name'];
      final version = info['version'];

      if (definitions == null) {
        throw 'No script definitions were found';
      }

      final f_arg = arguments.first; // only the first argument will be used
      final script = definitions.containsKey(f_arg)
          ? parseDefinitions(definitions[f_arg])
          : null;

      if (script == null) {
        throw 'Script not found';
      }

      print('> $name@$version $f_arg ${Directory.current.path}');
      switch (script.execution) {
        case 'once':
          executor(
              '${script.scripts.join(' && ')} ${scriptArguments.join(' ')}');
          break;
        case 'multiple':
          for (final s in script.scripts) {
            executor('$s ${scriptArguments.join(' ')}');
          }
          break;
        default:
          throw 'Incorrect execution type ${script.execution}';
          break;
      }
    }
  }
}
