import 'package:equatable/equatable.dart';

/// A typical script definition
///
/// [execution] - is the type to execute the scripts,
/// can be `multiple` or `once`, `multiple` by default.
///
/// [description] - is a short descriptive message about
/// the script which will be shown when you use `derry ls -d`.
///
/// [scripts] - is a list of commands/scripts to execute.
class Definition extends Equatable {
  /// Constructs a constant [Defintion] instance.
  const Definition({
    this.execution = 'multiple',
    this.description = '',
    this.scripts,
  });

  /// Type of execution to be done.
  ///
  /// Possible values are 'multiple' and 'once'.
  final String execution;

  /// Description message.
  final String description;

  /// Scripts contained in the definition.
  final List<String> scripts;

  @override
  List<Object> get props => [execution, scripts];
}
