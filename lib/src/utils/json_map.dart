import '../../utils.dart';

/// Json serializable map.
typedef JsonMap = Map<String, dynamic>;

extension ToJsonMapExtension on Map {
  /// Takes a `Map` and returns a `JsonMap`
  JsonMap toJsonMap() {
    final self = this;
    return self.map((key, value) =>
        MapEntry(key.toString(), value is Map ? value.toJsonMap() : value));
  }
}

extension JsonMapExtension on JsonMap {
  /// Gets valid paths to access values from a map of script definitions.
  List<String> getPaths() {
    final self = this;
    final result = <String>[];
    for (final k in self.keys) {
      if (self[k] is JsonMap && k != scriptsDefinitionKey) {
        result.addAll((self[k] as JsonMap).getPaths().map((v) => '$k $v'));
      } else if (RegExp(r'\(\w+\)').matchAsPrefix(k) != null) {
        result.add('');
      } else {
        result.add(k);
      }
    }
    return result.map((v) => v.trim()).toSet().toList();
  }

  /// Searches for a given path in the map.
  dynamic lookup(String path) {
    var data = this;
    final keys = path.trim().split(' ');
    for (final entry in keys.asMap().entries) {
      final isLastKey = entry.key == keys.length - 1;
      final key = entry.value;
      final value = data[key];
      if (!isLastKey && value is JsonMap) {
        data = value;
        continue;
      }
      return value;
    }
  }
}
