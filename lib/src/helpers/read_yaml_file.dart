part of derry;

/// read and return yaml document
Future<YamlDocument> readYamlFile(String filePath) async {
  final file = File(filePath);
  YamlDocument document;

  if (!await file.exists()) {
    throw Error(
      type: ErrorType.FNF,
      body: {'path': filePath},
    );
  }

  try {
    document = loadYamlDocument(await file.readAsString());
  } catch (e) {
    throw Error(type: ErrorType.CPY);
  }

  return document;
}
