import 'dart:io';

import 'package:derry/error.dart' show DerryError, ErrorCode;
import 'package:derry/utils.dart' show JsonMap, ToJsonMapExtension, readYamlMap, Info;
import 'package:path/path.dart' as path;

const String pubspecFileName = 'pubspec.yaml';
const String scriptsKey = 'scripts';

/// A singleton class that reads and caches the content of
/// `pubspec.yaml` in current directory and provides utilities
/// for .
class Pubspec {
  /// File path of `pubspec.yaml` in current directory.
  static final String filePath = path.join(Directory.current.path, pubspecFileName);

  /// Text content of `pubspec.yaml` once it has been read,
  /// used as a mean of memoization.
  static JsonMap? content;

  /// Loads the content of `pubspec.yaml` in current directory,
  /// this methods must be called before any other method.
  Future<JsonMap> getContent() async {
    content ??= await readYamlMap(filePath).then((map) => map.toJsonMap());
    return content!;
  }

  /// Returns basic information about the package
  /// defined in `pubspec.yaml`.
  Future<Info> getInfo() async {
    final content = await getContent();
    return Info(
      name: content['name'] as String?,
      version: content['version'] as String?,
    );
  }

  /// The file path where the scripts are defined,
  /// used as a mean of memoization.
  static String? source;

  /// Returns the file path where the scripts are defined
  /// which can be either `pubspec.yaml` or a file path
  /// defined in `pubspec.yaml`.
  Future<String> getSource() async {
    source ??= await _getSourceUncached();
    return source!;
  }

  Future<String> _getSourceUncached() async {
    final content = await getContent();
    final scripts = content[scriptsKey];

    if (scripts == null) {
      throw DerryError(type: ErrorCode.missingScripts);
    }

    if (scripts is Map) {
      return pubspecFileName;
    } else if (scripts is String) {
      return scripts;
    } else {
      throw DerryError(type: ErrorCode.invalidScripts);
    }
  }

  /// A map of scripts defined in `pubspec.yaml`,
  /// used as a mean of memoization.
  static JsonMap? scripts;

  /// Returns a map of scripts defined in `pubspec.yaml`
  /// or the scripts from the file path defined in `pubspec.yaml`.
  Future<JsonMap> getScripts() async {
    scripts ??= await _getScriptsUncached();
    return scripts!;
  }

  Future<JsonMap> _getScriptsUncached() async {
    final source = await getSource();

    if (source == pubspecFileName) {
      final content = await getContent();
      return content[scriptsKey] as JsonMap;
    }

    return readYamlMap(source).then((map) => map.toJsonMap());
  }
}
