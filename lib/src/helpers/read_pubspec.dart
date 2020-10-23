import 'dart:io' show Directory;
import 'package:yaml/yaml.dart';
import 'package:derry/src/helpers/read_yaml_file.dart';

/// read and return pubspec.yaml in current directory
Future<YamlDocument> readPubspec() async {
  return readYamlFile('${Directory.current.path}/pubspec.yaml');
}
