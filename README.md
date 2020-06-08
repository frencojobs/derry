# Derry

Derry is a script manager for dart.

## Overview

Derry helps you define shortcut scripts, and save you from having to type very long and forgettable long lines of scripts, again and again.

Instead of running this everytime,

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
```

## Installation

Install derry as a global dependency from pub as follows.

```bash
pub global activate derry
```

Then use derry to run a command from the current dart/flutter project.

```bash
derry run [script]
```

## Usage

When called, derry will look for a `pubspec.yaml` file in the current directory, and will throw an error if not exist. The scripts can be declared within the the `scripts` node of the `pubspec` file.

```yaml
scripts:
  build: pub run build_runner build
```

```bash
derry run build
# or even with additional arguments
derry run build --delete-conflicting-ouptpus
```

## Configuration

Scripts can be configured just inside the `pubspec.yaml` file or within a separate file. When using a seperate file to configure scripts, pass the file name as the value of the `scripts` node in the `pubspec.yaml` file.

```yaml
# pubspec.yaml
scripts: scripts.yaml
```

```yaml
# scripts.yaml
build: pub run build_runner build
```

A script can either be a single string or a list of strings. If it is a list, the strings inside of string will be executed synchronously in the given order of the list.

```yaml
build:
  - pub run test
  - echo "test completed"
  - pub run build_runner build
```

Note that the executions will happen in separated processes, use `&&` to execute multiple scripts in the same process. Alternatively, you can also configure `execution` value.

```yaml
build:
  execution: once # multiple by default
  scripts:
    - cat generated.txt
    - pub run build_runner build # won't be called if generated.txt does not exist
```

This will be the same as using `&&` but it saved the user from having very long lines of scripts.

## Why & How

Honestly, I needed it. It was easy to made, though I had a hard time implementing the script execution. Since Dart's `Process` isn't really good at executing system commands, I used Rust with the help of _Foreign Function Interfaces_. For execution, currently `cmd` is used for Windows and `bash` is used for Linux and Mac. I know that's not optimal and I'm still looking for a way to allow user to use current shell for executions.

## License

MIT &copy; Frenco Jobs
