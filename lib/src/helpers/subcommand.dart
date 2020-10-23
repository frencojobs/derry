Map<String, String> subcommand(String command) {
  if (command.startsWith('\$')) {
    final sub = command.split(' ').first.substring(1);
    return {
      'command': sub.split(':').join(' '),
      'extra': command.split(' ').sublist(1).join(' '),
    };
  } else {
    return {
      'command': '',
      'extra': '',
    };
  }
}
