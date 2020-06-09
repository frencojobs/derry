import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

// took this piece of code from dart/tflite_native
/// supported operating systems with architectures
const Set<String> supported = {'win64', 'linux64', 'mac64'};

/// get the file name of blob files based on os
/// file name doesn't include directory paths
String getObject() {
  final architecture = ffi.sizeOf<ffi.IntPtr>() == 4 ? '32' : '64';
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
    throw 'Unsupported platform!';
  }

  final result = os + architecture;
  if (!supported.contains(result)) {
    throw 'Unsupported platform: $result!';
  }

  return 'executor_$result.$extension';
}
