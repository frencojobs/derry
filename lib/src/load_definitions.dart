part of derry;

/// load scripts from pubspec yaml content
Future<Map> loadDefinitions() async {
  final pubspec = await readPubspec();
  final definitions = pubspec.contents.value['scripts'];

  if (definitions == null) {
    throw Error(type: ErrorType.DNF);
  }

  if (definitions is YamlMap) {
    return definitions.value;
  } else if (definitions is String) {
    final fileScripts = await readYamlFile(definitions.toString());

    if (fileScripts.contents.value is Map) {
      return fileScripts.contents.value;
    } else {
      throw Error(type: ErrorType.CPD);
    }
  } else {
    throw Error(type: ErrorType.CPD);
  }
}
