## 1.0.4

- Refactor to not expose all APIs but only important ones so most library APIs will not be available
- Add more documentation comments

## 1.0.3

- Format error types in error messages to be uppercase

## 1.0.2

- Rename `derry update` command to `derry upgrade`
- Fix type casting error on extra arguments

## 1.0.1

- Formatted changelogs according to pub.dev

## 1.0.0

- Today I learned how versioning system actually works

## 0.1.4

- Derry now uses `lint` instead of `pedantic` as code linter & analyzer
- Code base is now formatted according to the `lint`'s rules
- Use `stdout` and `stderr` instead of `print`

## 0.1.3

- Add support for nested subcommands like `$generate:env` to run as `derry generate env`
- Add support for `derry update` command
- Sort output of `derry ls` tree
- Remove alias list

## 0.1.2

- Now `run` scripts can be used without using the `run` keyword. For example, `derry test` can be used instead of `derry run test` without explicit implementations, for all scripts
- Removed the old `build` and `test` alias implementations
- The derry commands no longer print the current directory on the script execution

## 0.1.1+1

- Updated the pub link in README.md from `http` to `https` to get better pub score

## 0.1.1

- Refactored ffi directory to bindings directory
- Refactored usage lines to be all lowercase and with no period
- Added `derry --version` option

## 0.1.0

- Added support for `derry source` command

## 0.0.9

- Added support for using subcommands with options/arguments/parameters

## 0.0.8+1

- Fixed #20 `MultipleHandlers` Error caused by #12 fix

## 0.0.8

- Fixed #12 Ctrl-C Error
- Added `-s` as abbrreviation for `--silent`

## 0.0.7+1

- Fixed #14 error on not being able to use options caused by previous changes

## 0.0.7

- Added support for nested scripts
- Modified `Did you mean this?` check and `ls` commands to work well with nested scripts
- Breaking changes on `Advanced Configuration` API for compatibility with nested scripts

## 0.0.6

- Added `Did you mean this?` check by using `string-similarity` package
- Fixed null infoLine error
- Fixed command not found unhandled exceptions

## 0.0.5

- Added `derry ls` command
- Updated documentation

## 0.0.4

- Added support for `test` and `build` aliases
- Better and consistent error messages with an API

## 0.0.3+1

- Modified README to work correctly on pub.dev

## 0.0.3

- Added support for `--silent`
- Refactored Rust source code
- Started using derry for build
- Modified documentation

## 0.0.2

- Added support for subcommands

## 0.0.1

- Initial version, scaffolded by Stagehand
- Added support for list definitions
- Added support for configurable execution type
- Added support for win64, linux64, and (mac64)
- Added tests for helpers
