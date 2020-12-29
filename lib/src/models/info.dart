import 'package:equatable/equatable.dart';

/// Package information which includes
/// package name & version with both being [String].
class Info extends Equatable {
  /// Constructs a constant [Info] instance.
  const Info({
    this.name,
    this.version,
  });

  /// The name of the package.
  final String name;

  /// The version of the package.
  final String version;

  @override
  List<Object> get props => [name, version];
}
