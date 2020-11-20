// Dart imports:
import 'dart:cli' as cli;
import 'dart:ffi' as ffi;
import 'dart:isolate' show Isolate;

// Package imports:
import 'package:ffi/ffi.dart' show Utf8;

// Project imports:
import 'package:derry/src/bindings/get_object.dart';

typedef executor_fn = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Int32);
typedef Executor = void Function(ffi.Pointer<Utf8>, int);

// ignore: avoid_positional_boolean_parameters
void executor(String input, bool silent) {
  const rootLibrary = 'package:derry/derry.dart';
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
