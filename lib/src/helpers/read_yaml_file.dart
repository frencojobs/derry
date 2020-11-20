// Dart imports:
import 'dart:io';

// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:derry/error.dart';
import 'package:derry/models.dart';

/// read and return yaml document
Future<YamlDocument> readYamlFile(String filePath) async {
  final file = File(filePath);
  YamlDocument document;

  if (!await file.exists()) {
    throw DerryError(
      type: ErrorType.fnf,
      body: {'path': filePath},
    );
  }

  try {
    document = loadYamlDocument(await file.readAsString());
  } catch (e) {
    throw const DerryError(type: ErrorType.cpy);
  }

  return document;
}
