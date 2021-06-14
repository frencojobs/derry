import 'package:derry/error.dart';
import 'package:equatable/equatable.dart';

/// A custom error type used to catch custom errors
/// with the type [ErrorType].
class DerryError extends Equatable {
  /// Type of error.
  final ErrorType type;

  /// Body message of the error.
  final Map<String, dynamic> body;

  /// Constructs a constant [DerryError] instance.
  const DerryError({
    this.type,
    this.body,
  });

  @override
  List<Object> get props => [type, body];
}
