import 'package:yaml/yaml.dart';

import 'package:derry/error.dart';
import 'package:derry/models.dart';

/// Parses a list from yaml input.
List<String> toList(dynamic input) {
  if (input is YamlList) {
    return input.toList().map((e) => e.toString()).toList();
  } else if (input is String) {
    return [input.toString()];
  } else {
    throw DerryError(
      type: ErrorType.cct,
      body: {
        'from': input.runtimeType,
        'to': 'List<String>',
      },
    );
  }
}
