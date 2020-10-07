part of derry;

/// read and return pubspec.yaml in current directory
Future<YamlDocument> readPubspec() async {
  return readYamlFile('${Directory.current.path}/pubspec.yaml');
}
