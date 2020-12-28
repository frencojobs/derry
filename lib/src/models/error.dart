import 'package:equatable/equatable.dart';

import 'package:derry/error.dart';

/// A custom error type used to catch custom errors
/// with the type [ErrorType].
class DerryError extends Equatable {
  /// Constructs a constant [DerryError] instance.
  const DerryError({
    this.type,
    this.body,
  });

  /// Type of error.
  final ErrorType type;

  /// Body message of the error.
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [type, body];
}
