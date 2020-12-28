import 'package:yaml/yaml.dart';

import 'package:derry/error.dart';
import 'package:derry/helpers.dart';
import 'package:derry/models.dart';

/// Finds the source of the derry config.
Future<String> findSource() async {
  final pubspec = await readPubspec();
  final definitions = pubspec.contents.value['scripts'];

  if (definitions == null) {
    throw const DerryError(type: ErrorType.dnf);
  }

  if (definitions is YamlMap) {
    return 'pubspec.yaml';
  } else if (definitions is String) {
    final fileScripts = await readYamlFile(definitions.toString());

    if (fileScripts.contents.value is YamlMap) {
      return definitions;
    } else {
      throw const DerryError(type: ErrorType.cpd);
    }
  } else {
    throw const DerryError(type: ErrorType.cpd);
  }
}
