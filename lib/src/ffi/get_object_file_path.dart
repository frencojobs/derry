import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

// took this code from dart/tflite_native
const Set<String> supported = {'win64'};
String getObjectFilePath() {
  final architecture = ffi.sizeOf<ffi.IntPtr>() == 4 ? '32' : '64';
  String os, extension;
  if (Platform.isLinux) {
    os = 'linux';
    extension = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    extension = 'so';
  } else if (Platform.isWindows) {
    os = 'win';
    extension = 'dll';
  } else {
    throw Exception('Unsupported platform!');
  }

  final result = os + architecture;
  if (!supported.contains(result)) {
    throw Exception('Unsupported platform: $result!');
  }

  return 'executor_$result.$extension';
}
