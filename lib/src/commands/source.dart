part of derry;

/// the `derry source` command
class SourceCommand extends Command {
  @override
  String get name => 'source';

  @override
  String get description => 'find the location of the derry config file';

  SourceCommand() {
    super.argParser.addFlag(
          'absolute',
          abbr: 'a',
          help: 'determine whether to show absolute paths or not',
          negatable: false,
        );
  }

  @override
  Future<void> run() async {
    final absolute = super.argResults['absolute'];

    if (absolute != null) {
      stdout.writeln(File(await findSource()).absolute.path);
    } else {
      stdout.writeln(await findSource());
    }
  }
}
