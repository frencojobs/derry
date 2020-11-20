// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:derry/helpers.dart';
import 'package:derry/models.dart';

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
