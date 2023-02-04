import 'package:derry/src/error/error_code.dart' show ErrorCode;
import 'package:equatable/equatable.dart' show EquatableMixin;

/// A custom error type used to catch custom errors
/// with the type [ErrorCode].
class DerryError extends Error with EquatableMixin {
  /// Type of error.
  final ErrorCode type;

  /// Body message of the error.
  final Map<String, dynamic> body;

  /// Constructs a constant [DerryError] instance.
  DerryError({
    required this.type,
    this.body = const {},
  });

  @override
  List<Object> get props => [type, body];
}
