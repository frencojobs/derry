part of derry;

List<String> makeKeys(dynamic input) {
  final result = [];

  for (final k in input.keys) {
    if (input[k] is Map) {
      result.addAll(makeKeys(input[k]).map((v) => '$k $v'));
    } else if (k is String && RegExp(r'\(\w+\)').matchAsPrefix(k) != null) {
      result.add('');
    } else {
      result.add(k);
    }
  }

  return result.map((v) => v.toString().trim()).toSet().toList();
}
