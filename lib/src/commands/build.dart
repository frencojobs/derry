part of derry;

class BuildCommand extends RunCommmand {
  @override
  bool get alias => true;

  @override
  String get name => 'build';

  @override
  String get description => 'alias to derry run build.';
}
