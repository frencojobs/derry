part of derry;

void execute(
  Map definitions,
  String arg, {
  String extra = '',
  bool silent = false,
  String infoLine,
}) {
  final definition =
      definitions.containsKey(arg) ? parseDefinitions(definitions[arg]) : null;

  if (definition == null) {
    throw Error(
      type: ErrorType.SNF,
      body: {'script': arg},
    );
  }

  infoLine ?? print(infoLine);
  switch (definition.execution) {
    case 'once':
      final script = definition.scripts.join(' && ');
      executor('$script $extra', silent);
      break;
    case 'multiple':
      for (final script in definition.scripts) {
        final sub = subcommand(script);
        if (sub.isNotEmpty) {
          execute(definitions, sub, extra: extra, silent: silent);
        } else {
          // replace all \$ with $ but are not subcommands
          final unparsed = script.replaceAll('\\\$', '\$');
          executor('$unparsed $extra', silent);
        }
      }
      break;
    default:
      throw 'Incorrect execution type ${definition.execution}.';
      break;
  }
}
