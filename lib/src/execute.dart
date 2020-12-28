import 'dart:io';

import 'package:console/console.dart';
import 'package:yaml/yaml.dart';

import 'package:derry/error.dart';
import 'package:derry/helpers.dart';
import 'package:derry/models.dart';
import 'package:derry/src/bindings/executor.dart';

/// The function to execute scripts from ffi, which
/// takes a [YamlMap] of definitions, an argument to parse and execute,
/// an extra bit of command which will be passed down to the script,
/// a `boolean` value to decide whether to print output
/// or not, and a [String] to print before executing the script.
int execute(
  Map definitions,
  String arg, {
  String extra = '',
  String infoLine,
}) {
  var hasPre = false, hasPost = false;

  try {
    search(definitions, 'pre$arg');
    hasPre = true;
  } on DerryError catch (_) {
    // don't mind
  }

  try {
    search(definitions, 'post$arg');
    hasPost = true;
  } on DerryError catch (_) {
    // don't mind
  }

  if (hasPre) {
    _execute(
      definitions,
      'pre$arg',
      extra: extra,
      infoLine: infoLine,
    );
  }

  final output = _execute(
    definitions,
    arg,
    extra: hasPre ? null : extra,
    infoLine: hasPre ? null : infoLine,
  );

  if (hasPost) {
    _execute(definitions, 'post$arg');
  }

  return output;
}

int _execute(
  Map definitions,
  String arg, {
  String extra = '',
  String infoLine,
}) {
  final searchResult = search(definitions, arg);

  /// for incomplete calls for nested scripts
  if (searchResult is YamlMap && !searchResult.value.containsKey('(scripts)')) {
    throw DerryError(
      type: ErrorType.snf,
      body: {
        'script': arg,
        'definitions': makeKeys(definitions),
      },
    );
  }

  final definition = parseDefinition(searchResult);

  Console.init();
  Console.setBold(true);
  if (infoLine != null) stdout.writeln(infoLine);
  Console.setBold(false);

  switch (definition.execution) {
    case 'once':
      final script = definition.scripts.join(' && ');
      return executor('$script $extra');
      break;
    case 'multiple':
      var exitCode = 0;
      for (final script in definition.scripts) {
        final sub = subcommand(script);
        if (sub['command'].isNotEmpty) {
          exitCode = execute(
            definitions,
            sub['command'],
            extra: sub['extra'],
          );
        } else {
          // replace all \$ with $, they are not subcommands
          final unparsed = script.replaceAll('\\\$', '\$');
          exitCode = executor('$unparsed $extra');
        }
      }
      return exitCode;
      break;
    default:
      throw 'Incorrect execution type ${definition.execution}.';
      break;
  }
}
