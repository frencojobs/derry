part of derry;

class TestCommand extends RunCommmand {
  @override
  bool get alias => true;

  @override
  String get name => 'test';

  @override
  String get description => 'alias to derry run test.';
}
