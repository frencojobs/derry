part of derry;

/// Function to handle errors based on [ErrorType].
void errorHandler(Error t) {
  final prefixer = format('derry {color.red}ERROR!{color.end}');

  stderr.writeln(
    '$prefixer ${t.type.toString().replaceAll('ErrorType.', '').toUpperCase()}',
  );

  switch (t.type) {
    case ErrorType.snf:
      final mainScript = t.body['script'] as String;
      final definitions = t.body['definitions'] as List<String>;

      stderr.writeln('$prefixer Unable to find script named "$mainScript".');
      stderr.writeln('');

      final bestMatch = StringSimilarity.findBestMatch(
        mainScript,
        definitions,
      ).bestMatch;

      if (bestMatch.rating >= 0.5) {
        stderr.writeln('$prefixer Did you mean this?');
        stderr.writeln('$prefixer    ${bestMatch.target}');
      }
      break;
    case ErrorType.dnf:
      stderr.writeln('$prefixer Unable to find definitions.');
      break;
    case ErrorType.iet:
      stderr.writeln('$prefixer Unable to parse definitions.');
      stderr.writeln(
        '$prefixer The definitions are not correctly defined in the right format.',
      );
      break;
    case ErrorType.pns:
      stderr.writeln('$prefixer Unsupported plaform.');
      if (t.body.containsKey('os')) {
        stderr.writeln(
          '$prefixer Unsupported operating system "${t.body['os']}".',
        );
      } else if (t.body.containsKey('architecture')) {
        stderr.writeln(
          '$prefixer Unsupported architecture "${t.body['architecture']}".',
        );
      }
      break;
    case ErrorType.cpy:
      stderr.writeln('$prefixer Incorrect YAML format.');
      break;
    case ErrorType.cpd:
      stderr.writeln('$prefixer Incorrect definition format.');
      break;
    case ErrorType.cct:
      stderr.writeln('$prefixer Unable to cast to type required.');
      stderr.writeln(
        '$prefixer "${t.body['from']}" can\'t be casted into "${t.body['to']}"',
      );
      break;
    case ErrorType.fnf:
      stderr.writeln('$prefixer File Not Found at "${t.body['path']}"');
      break;
  }
}
