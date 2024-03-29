# Derry

Derry is a script manager for Dart.

## Overview

Derry helps you define shortcut scripts, and save you from having to type very long and forgettable long lines of scripts, again and again.

Instead of running this every time,

```bash
dart run build_runner build --delete-conflicting-outputs
```

Add this to `pubspec.yaml`,

```yaml
scripts:
  build: dart run build_runner build --delete-conflicting-outputs
```

and run

```bash
derry build
```

<br>

## Installation

Install derry as a global dependency from [pub.dev](https://pub.dev) like this.

```bash
dart pub global activate derry
```

Then use derry to run a command from the current dart/flutter project.

```bash
derry [script]
```

<br>

## Usage

When called, derry will look for a `pubspec.yaml` file in the current directory, and will throw an error if it doesn't exist. The scripts can be declared within the `scripts` node of the `pubspec.yaml` file.

```yaml
scripts:
  build: dart run build_runner build
```

```bash
derry build
# or even with additional arguments
derry build -- --delete-conflicting-outputs
```

<br>

## API Documentation

**Use definition file**

Scripts can be configured just inside the `pubspec.yaml` file or within a separate file. When using a separate file to configure scripts, pass the file name as the value of the `scripts` node in the `pubspec.yaml` file.

```yaml
# pubspec.yaml
scripts: derry.yaml
```

```yaml
# derry.yaml
build: dart run build_runner build
```

**Use scripts as List**

A script can either be a single string or a list of strings. If it is a list, the strings inside of the list will be executed synchronously in the given order of the list.

```yaml
build:
  - dart test
  - echo "test completed"
  - dart run build_runner build
```

**Nested scripts**

Scripts can be nested as the user needed. For example, you can use them to use different implementations of the build script based on operating system.

```yaml
build:
  windows:
    - echo 0 # do something
  mac:
    - echo 1 # do something else
```

And you can use them by calling `derry build windows` on windows and `derry build mac` on macOS.

**Pre and post scripts**

With pre & post scripts, you can easily define a script to run before and after a specific script without hassling with references. Derry automatically understands them from the names.

```yaml
prepublish:
  - cargo build && copy target blob
  - dart test
publish:
  - dart pub publish
postpublish:
  - rm -rf blob
```

**Configure script descriptions**

You can add a string to `(description)` option, which can be useful when viewing through a list of available via `derry ls -d` command. When you are using `(description)` field, you must use `(script)` field to define scripts.

```yaml
build:
  (description): script to be called after every update to x.dart file
  (scripts):
    - cat generated.txt
    - dart run build_runner build
```

**Configure multiline scripts**

Note that in the list of scripts, executions will happen in separate processes. You can use `&&` to execute multiple scripts in the same process.

```yaml
# > or | can be used to define multiline strings, this is a standard YAML syntax
build: >
  cat generated.txt &&
  dart run build_runner build

# the second line won't be called if generated.txt does not exist
```

**Use references**

When defining scripts, you can reference to other scripts via `$` syntax. These references to scripts won't be executed with a separate derry process. For example,

```yaml
test:
  - dart run test
  - echo "test completed"
build:
  - $test # instead of using derry test
  - $test --ignored # even with arguments
  - flutter build
generate:
  env:
    - echo env
release:
  - $generate:env # use nested references via :
  - $build
```

`derry test` will spawn a new derry process to execute, while references won't, reducing the time took to run dart code, and spawn that process.
But note that references will take a whole line of script. For example, you have to give a separate line for a subcommand, you can't use them together with other scripts or sandwiched in a string.

**List available scripts**

Use this command to see what scripts are available in the current configuration.

```bash
derry ls # --description or -d to output descriptions
```

**Check the location of the derry scripts**

Use this command to see the location (both absolute and relative) path of the derry script file. You can also use this to check if the scripts are correctly formatted or the location is correct.

```bash
derry source # --absolute or -a to show absolute path
```

**Upgrade derry**

```bash
dart pub global activate derry # or
derry upgrade # will run `dart pub global activate derry`
```

<br>

## Why & How

Honestly, I needed it. It was easy to make, though I had a hard time implementing the script execution. Since Dart's `Process` isn't good at executing system commands, I used Rust with the help of _Foreign Function Interfaces_. For execution, currently `cmd` is used for Windows and `bash` is used for Linux and Mac.

<br>

## Currently Supported Platforms

64bit Linux, Windows, and Mac are currently supported.
