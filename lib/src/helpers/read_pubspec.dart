// Dart imports:
import 'dart:io';

// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:derry/helpers.dart';

/// read and return pubspec.yaml in current directory
Future<YamlDocument> readPubspec() async {
  return readYamlFile('${Directory.current.path}/pubspec.yaml');
}
