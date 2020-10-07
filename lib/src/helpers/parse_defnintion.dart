part of derry;

Definition parseDefinition(dynamic input) {
  if (input is YamlMap) {
    return Definition(
      execution: input.value['(execution)'] as String,
      scripts: toList(input.value['(scripts)']),
    );
  } else {
    return Definition(
      scripts: toList(input),
    );
  }
}
