part of derry;

/// read and return pubspec.yaml in current directory
Future<YamlDocument> readPubspec() async {
  final pubspec = File(Directory.current.path + '/pubspec.yaml');
  YamlDocument document;

  if (!await pubspec.exists()) {
    throw 'No pubspec.yaml file found';
  }

  try {
    document = loadYamlDocument(await pubspec.readAsString());
  } catch (e) {
    throw 'YAML File can\'t be parsed';
  }

  return document;
}
