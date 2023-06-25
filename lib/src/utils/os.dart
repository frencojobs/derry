import 'dart:io';

import '../../error.dart';

/// enum for OS types.
enum OS {
  linux(key: '(linux)'),
  mac(key: '(mac)'),
  windows(key: '(windows)'),
  defaultOs(key: '(default)');

  const OS({required this.key});

  /// The key used in yaml files to reference the OS.
  final String key;

  @override
  String toString() => key;

  /// method that returns all the keys
  static List<String> getKeys() {
    return OS.values.map((e) => e.key).toList();
  }

  bool matchesCurrentOS() {
    if (this == OS.defaultOs) return true;
    if (Platform.isLinux && this == OS.linux) return true;
    if (Platform.isMacOS && this == OS.mac) return true;
    if (Platform.isWindows && this == OS.windows) return true;
    return false;
  }

  static OS fromString(String key) {
    if (!OS.getKeys().contains(key)) {
      throw DerryError(type: ErrorCode.invalidOs, body: {'os': key});
    }
    return OS.values.firstWhere((element) => element.key == key);
  }
}
