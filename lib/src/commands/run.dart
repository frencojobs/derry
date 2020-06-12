part of derry;

/// the `derry run` command
class RunCommmand extends Command {
  bool get alias => false;

  @override
  String get name => 'run';

  @override
  String get description =>
      'Find the script definition from pubspec.yaml and execute it.';

  RunCommmand() {
    super.argParser.addFlag(
          'silent',
          help: 'Determine whether to show outputs or not.',
          defaultsTo: false,
          negatable: false,
        );
  }

  @override
  Future<void> run() async {
    final args = super.argResults.arguments;
    final silent = super.argResults['silent'];

    if (args.isEmpty && !alias) {
      print(super.usage);
    } else {
      final arg =
          alias ? name : args.first; // only the first argument will be used
      final extra = args.contains('--') // additional arguments
          ? args.sublist(args.indexOf('--') + 1).join(' ')
          : '';

      final info = await loadInfo();
      final definitions = await loadDefinitions();
      final infoLine = '> ${info.name}@${info.version} $arg ${info.pwd}';

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
