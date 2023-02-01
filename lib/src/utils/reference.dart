import 'package:equatable/equatable.dart';

const String referencePrefix = '\$';
const String referenceNestingDelimiter = ':';

/// A helper class to represent a reference to a script.
class Reference extends Equatable {
  @override
  List<Object> get props => [script, extra];

  /// The script referenced to run.
  final String script;

  /// The extra bit of command to pass down to the script.
  final String extra;

  /// Constructs a constant [Reference] instance.
  const Reference({
    required this.script,
    required this.extra,
  });

  /// Creates a [Reference] instance from a [String] input.
  /// The input string must start with a single character
  /// as specified via [referencePrefix].
  factory Reference.from(String input) {
    final paths = input.substring(1).split(' ');

    final script = paths.first;
    final extra = paths.sublist(1).join(' ');

    return Reference(
      script: script.split(referenceNestingDelimiter).join(' '),
      extra: extra,
    );
  }
}
