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
    final args = super.argResults.arguments;
    if (args.isEmpty) {
      print(super.usage);
    } else {
      final arg = args.first; // only the first argument will be used
      final extra = args.contains('--') // additional arguments
          ? args.sublist(args.indexOf('--') + 1).join(' ')
          : '';

      final info = await loadInfo();
      final definitions = await loadDefinitions();
      final infoLine = '> ${info.name}@${info.version} $arg ${info.pwd}';

      if (definitions == null) {
        throw 'No script definitions were found';
      }

      print(infoLine);
      execute(definitions, arg, extra);
    }
  }
}
