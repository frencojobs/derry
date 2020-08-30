part of derry;

/// Package information
class Info extends Equatable {
  final String name;
  final String version;

  Info({
    this.name,
    this.version,
  });

  @override
  List<Object> get props => [name, version];
}
