part of derry;

/// A typical script definition
///
/// [execution] - is the type to execute the scripts,
/// can be `multiple` or `once`, `multiple` by default.
///
/// [scripts] - is a list of commands/scripts to execute.
class Definition extends Equatable {
  final String execution;
  final List<String> scripts;

  const Definition({
    this.execution = 'multiple',
    this.scripts,
  });

  @override
  List<Object> get props => [execution, scripts];
}
