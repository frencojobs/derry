import 'dart:ffi' show IntPtr, sizeOf;
import 'dart:io';

import 'package:derry/error.dart';
import 'package:derry/models.dart';

// This piece of code was actually taken from
// dart/tflite_native

/// Supported operating systems with architectures.
const supported = {'win64', 'linux64', 'mac64'};

/// Gets the file name of blob files based on os
///
/// File name doesn't contain directory paths.
String getObject() {
  final architecture = sizeOf<IntPtr>() == 4 ? '32' : '64';
  String os, extension;
  if (Platform.isLinux) {
    os = 'linux';
    extension = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    extension = 'dylib';
  } else if (Platform.isWindows) {
    os = 'win';
    extension = 'dll';
  } else {
    throw DerryError(
      type: ErrorType.pns,
      body: {'os': Platform.operatingSystem},
    );
  }

  final result = os + architecture;
  if (!supported.contains(result)) {
    throw DerryError(
      type: ErrorType.pns,
      body: {'architecture': result},
    );
  }

  return 'executor_$result.$extension';
}
