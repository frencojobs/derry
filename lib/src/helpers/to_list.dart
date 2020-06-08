part of derry;

List<String> toList(input) {
  if (input is YamlList) {
    return input.toList().map((e) => e.toString()).toList();
  } else {
    return [input.toString()];
  }
}
