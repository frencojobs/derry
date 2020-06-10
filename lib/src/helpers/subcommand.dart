part of derry;

String subcommand(String command) {
  if (command.startsWith('\$')) {
    final sub = command.split(' ').first.substring(1);
    return sub;
  } else {
    return '';
  }
}
