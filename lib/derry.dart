library derry;

import 'dart:ffi'
    show
        Int32,
        Void,
        IntPtr,
        sizeOf,
        Pointer,
        NativeFunction,
        DynamicLibrary,
        NativeFunctionPointer;
import 'dart:cli' as cli;
import 'dart:isolate' show Isolate;
import 'dart:io' show Platform, File, Directory;

import 'package:yaml/yaml.dart';
import 'package:ffi/ffi.dart' show Utf8;
import 'package:console/console.dart' show format;
import 'package:args/command_runner.dart' show Command;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:string_similarity/string_similarity.dart';

import 'src/version.dart';
export 'src/version.dart';

part 'src/config.dart';
part 'src/execute.dart';
part 'src/load_info.dart';
part 'src/find_source.dart';
part 'src/load_definitions.dart';

part 'src/bindings/executor.dart';
part 'src/bindings/get_object.dart';

part 'src/error/handler.dart';
part 'src/error/error_type.dart';

part 'src/commands/ls.dart';
part 'src/commands/run.dart';
part 'src/commands/update.dart';
part 'src/commands/source.dart';

part 'src/models/info.dart';
part 'src/models/error.dart';
part 'src/models/definition.dart';

part 'src/helpers/to_list.dart';
part 'src/helpers/make_keys.dart';
part 'src/helpers/subcommand.dart';
part 'src/helpers/deep_search.dart';
part 'src/helpers/read_pubspec.dart';
part 'src/helpers/read_yaml_file.dart';
part 'src/helpers/parse_defnintion.dart';
