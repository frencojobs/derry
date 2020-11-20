// Package imports:
import 'package:equatable/equatable.dart';

/// Package information which includes
/// package name & version with both being [String].
class Info extends Equatable {
  final String name;
  final String version;

  const Info({
    this.name,
    this.version,
  });

  @override
  List<Object> get props => [name, version];
}
