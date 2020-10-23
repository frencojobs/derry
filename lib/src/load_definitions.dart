import 'package:yaml/yaml.dart';
import 'package:derry/derry.dart';
import 'package:derry/src/helpers/read_pubspec.dart';
import 'package:derry/src/helpers/read_yaml_file.dart';

/// load scripts from pubspec yaml content
Future<Map> loadDefinitions() async {
  final pubspec = await readPubspec();
  final definitions = pubspec.contents.value['scripts'];

  if (definitions == null) {
    throw const Error(type: ErrorType.dnf);
  }

  if (definitions is YamlMap) {
    return definitions.value;
  } else if (definitions is String) {
    final fileScripts = await readYamlFile(definitions.toString());

    if (fileScripts.contents.value is YamlMap) {
      return fileScripts.contents.value as Map;
    } else {
      throw const Error(type: ErrorType.cpd);
    }
  } else {
    throw const Error(type: ErrorType.cpd);
  }
}
