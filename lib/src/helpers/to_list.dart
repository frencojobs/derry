part of derry;

List<String> toList(dynamic input) {
  if (input is YamlList) {
    return input.toList().map((e) => e.toString()).toList();
  } else if (input is String) {
    return [input.toString()];
  } else {
    throw 'Uanble to cast input to list';
  }
}
