import 'dart:cli' as cli;
import 'dart:ffi' as ffi;
import 'dart:isolate' show Isolate;
import 'package:ffi/ffi.dart';
import 'package:derry/src/ffi/get_object.dart';

typedef executor_fn = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Int32);
typedef Executor = void Function(ffi.Pointer<Utf8>, int);

void executor(String input, bool silent) {
  final rootLibrary = 'package:derry/derry.dart';
  final blobs = cli
      .waitFor(Isolate.resolvePackageUri(Uri.parse(rootLibrary)))
      .resolve('src/blobs/');
  final objectFile = blobs.resolve(getObject()).toFilePath();
  final dylib = ffi.DynamicLibrary.open(objectFile);

  final executorPointer =
      dylib.lookup<ffi.NativeFunction<executor_fn>>('executor');
  final executorFunction = executorPointer.asFunction<Executor>();

  final script = Utf8.toUtf8(input).cast<Utf8>();
  executorFunction(script, silent ? 1 : 0);
}
