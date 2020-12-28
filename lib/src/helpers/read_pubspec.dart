import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:derry/helpers.dart';

/// Reads and returns the content of `pubspec.yaml` in
/// current directory.
Future<YamlDocument> readPubspec() async {
  return readYamlFile('${Directory.current.path}/pubspec.yaml');
}
