part of derry;

/// A custom error type used to catch custom errors
/// with the type [ErrorType].
class Error extends Equatable {
  final ErrorType type;
  final Map<String, dynamic> body;

  const Error({
    this.type,
    this.body,
  });

  @override
  List<Object> get props => [type, body];
}
