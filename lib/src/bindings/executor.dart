import 'dart:cli' as cli;
import 'dart:ffi' as ffi;
import 'dart:isolate' show Isolate;

import 'package:derry/src/bindings/get_object.dart';
import 'package:ffi/ffi.dart' show StringUtf8Pointer, Utf8;

/// Executes a given input string in console using the Rust code.
int executor(String input) {
  const rootLibrary = 'package:derry/derry.dart';
  final blobs = cli
      .waitFor(Isolate.resolvePackageUri(Uri.parse(rootLibrary)))
      .resolve('src/blobs/');
  final objectFile = blobs.resolve(getObject()).toFilePath();
  final dylib = ffi.DynamicLibrary.open(objectFile);

  final executorPointer =
      dylib.lookup<ffi.NativeFunction<_ExecutorFn>>('executor');
  final executorFunction = executorPointer.asFunction<_Executor>();

  return executorFunction(input.toNativeUtf8());
}

// ignore: avoid_private_typedef_functions
typedef _Executor = int Function(ffi.Pointer<Utf8>);
// ignore: avoid_private_typedef_functions
typedef _ExecutorFn = ffi.Int32 Function(ffi.Pointer<Utf8>);
