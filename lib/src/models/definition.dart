import 'package:equatable/equatable.dart';

/// A typical script definition
///
/// [execution] - is the type to execute the scripts,
/// can be `multiple` or `once`, `multiple` by default.
///
/// [scripts] - is a list of commands/scripts to execute.
class Definition extends Equatable {
  /// Constructs a constant [Defintion] instance.
  const Definition({
    this.execution = 'multiple',
    this.scripts,
  });

  /// Type of execution to be done.
  ///
  /// Possible values are 'multiple' and 'once'.
  final String execution;

  /// Scripts contained in the definition.
  final List<String> scripts;

  @override
  List<Object> get props => [execution, scripts];
}
