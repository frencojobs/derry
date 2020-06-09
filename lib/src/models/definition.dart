part of derry;

class Definition extends Equatable {
  final String execution;
  final List<String> scripts;

  Definition({
    this.execution = 'multiple',
    this.scripts,
  });

  @override
  List<Object> get props => [execution, scripts];
}
