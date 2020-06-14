import 'package:derry/derry.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('derry', 'A script runner/manager for dart.');

  runner
    ..addCommand(ListCommand())
    ..addCommand(RunCommmand())
    ..addCommand(TestCommand())
    ..addCommand(BuildCommand());

  try {
    await runner.run(arguments);
  } on Error catch (error) {
    errorHandler(error);
  } catch (error) {
    print(error);
  }
}
