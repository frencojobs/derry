part of derry;

void execute(Map definitions, String arg, [String extra = '']) {
  final definition =
      definitions.containsKey(arg) ? parseDefinitions(definitions[arg]) : null;

  if (definition == null) {
    throw 'Script not found';
  }
  switch (definition.execution) {
    case 'once':
      final script = definition.scripts.join(' && ');
      executor('$script $extra');
      break;
    case 'multiple':
      for (final script in definition.scripts) {
        final sub = subcommand(script);
        if (sub.isNotEmpty) {
          execute(definitions, sub);
        } else {
          // replace all \$ with $ but are not subcommands
          final unparsed = script.replaceAll('\\\$', '\$');
          executor('$unparsed $extra');
        }
      }
      break;
    default:
      throw 'Incorrect execution type ${definition.execution}';
      break;
  }
}
