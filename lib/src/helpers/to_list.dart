part of derry;

List<String> toList(dynamic input) {
  if (input is YamlList) {
    return input.toList().map((e) => e.toString()).toList();
  } else if (input is String) {
    return [input.toString()];
  } else {
    throw Error(
      type: ErrorType.cct,
      body: {
        'from': input.runtimeType,
        'to': 'List<String>',
      },
    );
  }
}
