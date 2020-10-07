part of derry;

void errorHandler(Error t) {
  final prefixer = format('derry {color.red}ERROR!{color.end}');

  stderr.write('$prefixer ${t.type.toString().replaceAll('ErrorType.', '')}');

  switch (t.type) {
    case ErrorType.snf:
      final mainScript = t.body['script'] as String;
      final definitions = t.body['definitions'] as List<String>;

      stderr.write('$prefixer Unable to find script named "$mainScript".');
      stderr.write('');

      final bestMatch = StringSimilarity.findBestMatch(
        mainScript,
        definitions,
      ).bestMatch;

      if (bestMatch.rating >= 0.5) {
        stderr.write('$prefixer Did you mean this?');
        stderr.write('$prefixer    ${bestMatch.target}');
      }
      break;
    case ErrorType.dnf:
      stderr.write('$prefixer Unable to find definitions.');
      break;
    case ErrorType.iet:
      stderr.write('$prefixer Unable to parse definitions.');
      stderr.write(
        '$prefixer The definitions are not correctly defined in the right format.',
      );
      break;
    case ErrorType.pns:
      stderr.write('$prefixer Unsupported plaform.');
      if (t.body.containsKey('os')) {
        stderr.write(
          '$prefixer Unsupported operating system "${t.body['os']}".',
        );
      } else if (t.body.containsKey('architecture')) {
        stderr.write(
          '$prefixer Unsupported architecture "${t.body['architecture']}".',
        );
      }
      break;
    case ErrorType.cpy:
      stderr.write('$prefixer Incorrect YAML format.');
      break;
    case ErrorType.cpd:
      stderr.write('$prefixer Incorrect definition format.');
      break;
    case ErrorType.cct:
      stderr.write('$prefixer Unable to cast to type required.');
      stderr.write(
        '$prefixer "${t.body['from']}" can\'t be casted into "${t.body['to']}"',
      );
      break;
    case ErrorType.fnf:
      stderr.write('$prefixer File Not Found at "${t.body['path']}"');
      break;
  }
}
