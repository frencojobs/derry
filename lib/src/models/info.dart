part of derry;

/// Package information
class Info extends Equatable {
  final String name;
  final String version;
  final String pwd = Directory.current.path;

  Info({
    this.name,
    this.version,
  });

  @override
  List<Object> get props => [name, version, pwd];
}
