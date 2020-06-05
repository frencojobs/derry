part of derry;

/// load scripts from pubspec yaml content
Future<YamlMap> loadDefinitions() async {
  final pubspec = await readPubspec();
  final YamlMap definitions = pubspec.contents.value['scripts'];

  return definitions;
}
