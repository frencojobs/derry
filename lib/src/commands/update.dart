part of derry;

/// the `derry update` command
class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'update derry itself';

  @override
  Future<void> run() async {
    {
      final infoLine = '> derry@${packageVersion} update';

      execute(
        {'update': 'pub global activate derry'},
        'update',
        infoLine: infoLine,
      );
    }
  }
}
