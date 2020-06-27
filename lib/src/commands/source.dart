part of derry;

/// the `derry source` command
class SourceCommand extends Command {
  @override
  String get name => 'source';

  @override
  String get description => 'Find the location of the derry scripts file';

  SourceCommand() {
    super.argParser.addFlag(
          'absolute',
          abbr: 'a',
          help: 'Determine whether to show absolute paths or not.',
          defaultsTo: false,
          negatable: false,
        );
  }

  @override
  Future<void> run() async {
    final absolute = super.argResults['absolute'];

    if (absolute) {
      print(File(await findSource()).absolute.path);
    } else {
      print(await findSource());
    }
  }
}
