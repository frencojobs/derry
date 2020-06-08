part of derry;

/// load package info from pubspec yaml content
Future<Map> loadInfo() async {
  final pubspec = await readPubspec();
  final name = pubspec.contents.value['name'];
  final version = pubspec.contents.value['version'];

  return {
    'name': name,
    'version': version,
  };
}
