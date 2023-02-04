import 'dart:io' show File, Directory;

import 'package:derry/error.dart' show DerryError, ErrorCode;
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' show YamlDocument, loadYamlDocument, YamlMap;

/// Reads a yaml file and if it exists, returns a yaml document.
Future<YamlDocument> _readYamlFile(String filePath) async {
  final file = File(path.join(Directory.current.path, filePath));
  if (!await file.exists()) {
    throw DerryError(
      type: ErrorCode.fileNotFound,
      body: {'path': filePath},
    );
  }
  final content = await file.readAsString();
  try {
    return loadYamlDocument(content);
  } catch (e) {
    throw DerryError(
      type: ErrorCode.invalidYaml,
      body: {'path': filePath, 'origin': e},
    );
  }
}

/// Reads and returns a yaml file if exists and
/// if the content is a map.
Future<Map> readYamlMap(String filePath) async {
  final document = await _readYamlFile(filePath);

  if (document.contents is! YamlMap) {
    throw DerryError(
      type: ErrorCode.invalidYamlMap,
      body: {
        'path': filePath,
        'content': document,
      },
    );
  }

  return document.contents.value as Map;
}
