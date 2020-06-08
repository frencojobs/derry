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
    final scriptArguments = [];

    if (arguments.contains('--')) {
      final index = arguments.indexOf('--');
      scriptArguments.addAll(arguments.sublist(index + 1));
    }

    if (arguments.isEmpty) {
      print(super.usage);
    } else {
      final definitions = await loadDefinitions();

      if (definitions == null) {
        throw 'No script definitions were found';
      }

      final f_arg = arguments.first;
      final script = definitions.containsKey(f_arg) ? definitions[f_arg] : null;

      if (script == null) {
        throw 'Script not found';
      }
      executor('$script ${scriptArguments.join(' ')}');
    }
  }
}
