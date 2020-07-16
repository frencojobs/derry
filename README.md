# Derry

![Pub Version](https://img.shields.io/pub/v/derry?color=ea728c&label=pub.dev&style=flat-square)

Derry is a script manager for Dart.

## Overview

Derry helps you define shortcut scripts, and save you from having to type very long and forgettable long lines of scripts, again and again.

Instead of running this every time,

```bash
pub run build_runner build --delete-conflicting-outputs
```

Add this to `pubspec.yaml`,

```yaml
scripts:
  build: pub run build_runner build --delete-conflicting-outputs
```

and run

```bash
derry run build
# or by alias
derry build
```

<br>

## Installation

Install derry as a global dependency from [Pub](https://pub.dev) as follows.

```bash
pub global activate derry
```

Then use derry to run a command from the current dart/flutter project.

```bash
derry run [script]
```

<br>

## Usage

When called, derry will look for a `pubspec.yaml` file in the current directory, and will throw an error if not exist. The scripts can be declared within the `scripts` node of the `pubspec.yaml` file.

```yaml
scripts:
  build: pub run build_runner build
```

```bash
derry build
# or use `silent` option to hide outputs
derry build --silent
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
build: pub run build_runner build
```

**Use scripts as List**

A script can either be a single string or a list of strings. If it is a list, the strings inside of the list will be executed synchronously in the given order of the list.

```yaml
build:
  - pub run test
  - echo "test completed"
  - pub run build_runner build
```

**Use aliases**

Most used scripts are defined as aliases that you can use with a shorter derry command. Options available with `derry run` command will also be available with these aliases. No other functionalities are added to these aliases, they are just extensions of `derry run` command.

```bash
derry build # instead of derry run build
derry test # instead of derry run test
```

**Nested scripts**

Scripts can be nested as the user needed. For example, you can use them to use different implementations of the build script based on operating system.

```yaml
# derry.yaml
build:
  windows:
    - echo 0 # do something
  mac:
    - echo 1 # do something else
```

And you can use them by calling `derry build windows` on windows and `derry build mac` on macOS.

**Configure execution type**

Note that in the list of scripts, executions will happen in separate processes, use `&&` to execute multiple scripts in the same process. Alternatively, you can also configure the `execution` value. To separate the configuration values from nested scripts, wrap the keys of the configurations with parenthesis as in `(execution)`.

```yaml
build:
  (execution): once # multiple by default
  (scripts):
    - cat generated.txt
    - pub run build_runner build # won't be called if generated.txt does not exist
```

This will be the same as using `&&` but it saved the user from having very long lines of scripts.

**Use subcommands**

When defining scripts, the user can also define subcommands. Subcommands are references to commands/scripts that won't be executed with a separate derry process. For example,

```yaml
test:
  - pub run test
  - echo "test completed"
build:
  - $test # instead of using derry test
  - $test --ignored # even with arguments
  - flutter build
```

`derry test` will spawn a new derry process to execute, while subcommands are not, reducing the time took to run dart code, and spawn that process.
But note that subcommands will take a whole line of script. For example, you have to give a separate line for a subcommand, you can't use them together with other scripts or sandwiched.

**List available scripts**

Use this command to see what scripts are available in the current configuration.

```bash
derry ls
```

**Check the location of the derry scripts**

Use this command to see the location (both absolute and relative) path of the derry script file. You can also use this to check if the scripts are correctly formatted or the location is correct.

```bash
derry source # --absolute or -a to show absolute path
```

<br>

## Why & How

Honestly, I needed it. It was easy to make, though I had a hard time implementing the script execution. Since Dart's `Process` isn't good at executing system commands, I used Rust with the help of _Foreign Function Interfaces_. For execution, currently `cmd` is used for Windows and `bash` is used for Linux and Mac. I know that's not optimal and I'm still looking for a way to allow users to use the current shell for executions.

<br>

## Currently Supported Platforms

64bit Linux, Windows, and Mac are currently supported.

<br>

## License

MIT &copy; Frenco Jobs
