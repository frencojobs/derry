// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:derry/error.dart';

/// A custom error type used to catch custom errors
/// with the type [ErrorType].
class DerryError extends Equatable {
  final ErrorType type;
  final Map<String, dynamic> body;

  const DerryError({
    this.type,
    this.body,
  });

  @override
  List<Object> get props => [type, body];
}
