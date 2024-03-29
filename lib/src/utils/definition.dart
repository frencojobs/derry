import 'package:equatable/equatable.dart';

/// Key used to define script description.
const String descriptionDefinitionKey = '(description)';

/// Key used to define scripts.
const String scriptsDefinitionKey = '(scripts)';

/// Parses a list from yaml input.
///
/// Can accept a `List` or a `String`.
List<String> _toStringList(dynamic input) {
  if (input is List) return input.toList().map((e) => e.toString()).toList();
  return [input as String];
}

/// A typical script definition.
///
/// [description] - is a short descriptive message about
/// the script which will be shown when you use `derry ls -d`.
///
/// [scripts] - is a list of commands/scripts to execute.
class Definition extends Equatable {
  @override
  List<Object?> get props => [description, scripts];

  /// Description message.
  final String? description;

  /// Scripts contained in the definition.
  final List<String> scripts;

  /// Constructs a constant [Defintion] instance.
  const Definition({
    this.description,
    required this.scripts,
  });

  /// Creates a [Definition] instance from a [dynamic] input.
  /// The input can be a [Map], [List] or [String].
  factory Definition.from(dynamic input) {
    if (input is Map) {
      final description = input[descriptionDefinitionKey] as String?;
      final scripts = input[scriptsDefinitionKey] as dynamic;

      return Definition(
        description: description,
        scripts: _toStringList(scripts),
      );
    } else {
      return Definition(scripts: _toStringList(input));
    }
  }
}
