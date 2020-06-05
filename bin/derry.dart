import 'package:derry/derry.dart';
import 'package:console/console.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('derry', 'A script runner/manager for dart.');

  runner.addCommand(RunCommmand());

  try {
    await runner.run(arguments);
  } catch (error) {
    print(format('{color.red}Error!{color.end} $error'));
  }
}
