import 'package:yaml/yaml.dart';
import 'package:derry/derry.dart';
import 'package:derry/src/helpers/to_list.dart';

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
