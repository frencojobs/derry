import 'package:derry/derry.dart';
import 'package:derry/src/helpers/read_pubspec.dart';

/// load package info from pubspec yaml content
Future<Info> loadInfo() async {
  final pubspec = await readPubspec();
  final name = pubspec.contents.value['name'] as String;
  final version = pubspec.contents.value['version'] as String;

  return Info(name: name, version: version);
}
