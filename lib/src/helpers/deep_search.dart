part of derry;

dynamic search(Map data, String key) {
  var d = data;
  var current = '';
  final keyPieces = key.split(' ');

  for (final entry in keyPieces.asMap().entries) {
    final i = entry.key;
    final k = entry.value;

    current += '$k ';
    if (d is Map && d.containsKey(k)) {
      if (i == keyPieces.length - 1) {
        return d[k];
      } else if (d[k] is Map) {
        d = d[k];
      } else {
        throw Error(
          type: ErrorType.SNF,
          body: {
            'script': key.trim(),
            'definitions': makeKeys(data),
          },
        );
      }
    } else {
      throw Error(
        type: ErrorType.SNF,
        body: {
          'script': current.trim(),
          'definitions': makeKeys(data),
        },
      );
    }
  }
}
