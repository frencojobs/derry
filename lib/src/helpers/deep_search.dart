import 'package:derry/error.dart';
import 'package:derry/helpers.dart';
import 'package:derry/models.dart';

/// Searches for a key in the definitions.
dynamic search(Map data, String key) {
  var d = data;
  final current = StringBuffer();
  final keyPieces = key.split(' ');

  for (final entry in keyPieces.asMap().entries) {
    final i = entry.key;
    final k = entry.value;

    current.write('$k ');
    if (d is Map && d.containsKey(k)) {
      if (i == keyPieces.length - 1) {
        return d[k];
      } else if (d[k] is Map) {
        d = d[k] as Map;
      } else {
        throw DerryError(
          type: ErrorType.snf,
          body: {
            'script': key.trim(),
            'definitions': makeKeys(data),
          },
        );
      }
    } else {
      throw DerryError(
        type: ErrorType.snf,
        body: {
          'script': current.toString().trim(),
          'definitions': makeKeys(data),
        },
      );
    }
  }
}
