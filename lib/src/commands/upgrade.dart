part of derry;

/// the `derry upgrade` command
class UpgradeCommand extends Command {
  @override
  String get name => 'upgrade';

  @override
  String get description => 'upgrade to the latest version of derry itself';

  @override
  Future<void> run() async {
    {
      const infoLine = '> derry@$packageVersion upgrade';

      execute(
        {'upgrade': 'pub global activate derry'},
        'upgrade',
        infoLine: infoLine,
      );
    }
  }
}
