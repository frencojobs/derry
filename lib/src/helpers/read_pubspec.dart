import 'dart:io';

import 'package:derry/helpers.dart';
import 'package:yaml/yaml.dart';

/// Reads and returns the content of `pubspec.yaml` in
/// current directory.
Future<YamlDocument> readPubspec() async {
  return readYamlFile('${Directory.current.path}/pubspec.yaml');
}
