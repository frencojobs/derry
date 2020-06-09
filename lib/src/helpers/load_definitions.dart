part of derry;

/// load scripts from pubspec yaml content
Future<YamlMap> loadDefinitions() async {
  final pubspec = await readPubspec();
  final definitions = pubspec.contents.value['scripts'];

  if (definitions == null) {
    throw 'Unable to locate scripts';
  }

  if (definitions is YamlMap) {
    return definitions;
  } else if (definitions is String) {
    final fileScripts = await readYamlFile(definitions.toString());

    if (fileScripts.contents.value is YamlMap) {
      return fileScripts.contents.value;
    } else {
      throw 'Unsupported scripts format';
    }
  } else {
    throw 'Unsupported scripts format';
  }
}
