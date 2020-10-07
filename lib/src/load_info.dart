part of derry;

/// load package info from pubspec yaml content
Future<Info> loadInfo() async {
  final pubspec = await readPubspec();
  final name = pubspec.contents.value['name'] as String;
  final version = pubspec.contents.value['version'] as String;

  return Info(name: name, version: version);
}
