## 1.5.1

- Add support for platform dependent scripts

## 1.5.0

- Add support for M1 Macs
- Blob sizes are now much smaller
- Opted-in to sound null-safety
- Rewrite most of the existing codes to be more concise and clearer, and also more performant by reducing io reads as much as possible and by caching a lot
- Use meaningful error codes with better error messages
- Rename `subcommands` to `references`
- Remove "execution type" which is useless and confusing
- Publishing is now done via GitHub Actions

## 1.4.3

- Bump version to correct `derry --version`

## 1.4.2

- Fix a bug by correctly passing extra arguments to parsed subcommands

## 1.4.1

- Add description option usage to README documentation

## 1.4.0

- Add description option which can now be used by `derry ls -d` command

## 1.3.0

- Update dependencies
- Refactor code with organized imports and typedefs according to new formatter rules

## 1.2.1

- Normalize absolute paths for `derry source` command
- Format old changelogs

## 1.2.0

- Enforce stricter linter rules and refactor according to it
- Support `pre` & `post` scripts
- Move native code into a separate directory

## 1.1.1

- Format according to `dartfmt` to get better pub score

## 1.1.0

- Scripts now return exit codes
- Remove `--slient` or `-s` option from `run` command
- Change info lines' styles
- Reduce exported API elements to only commands and version

## 1.0.5

- Update pub package description

## 1.0.4

- Refactor to not expose all APIs but only important ones so most library APIs will not be available
- Add more documentation comments

## 1.0.3

- Format error types in error messages to be uppercase

## 1.0.2

- Rename `derry update` command to `derry upgrade`
- Fix type casting error on extra arguments

## 1.0.1

- Format changelogs according to pub.dev

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
- Remove the old `build` and `test` alias implementations
- The derry commands no longer print the current directory on the script execution

## 0.1.1+1

- Update the pub link in README.md from `http` to `https` to get better pub score

## 0.1.1

- Refactor ffi directory to bindings directory
- Refactor usage lines to be all lowercase and with no period
- Adde `derry --version` option

## 0.1.0

- Add support for `derry source` command

## 0.0.9

- Add support for using subcommands with options/arguments/parameters

## 0.0.8+1

- Fix #20 `MultipleHandlers` Error caused by #12 fix

## 0.0.8

- Fix #12 Ctrl-C Error
- Add `-s` as abbrreviation for `--silent`

## 0.0.7+1

- Fix #14 error on not being able to use options caused by previous changes

## 0.0.7

- Add support for nested scripts
- Modify `Did you mean this?` check and `ls` commands to work well with nested scripts
- Breaking changes on `Advanced Configuration` API for compatibility with nested scripts

## 0.0.6

- Add `Did you mean this?` check by using `string-similarity` package
- Fix null infoLine error
- Fix command not found unhandled exceptions

## 0.0.5

- Add `derry ls` command
- Updat documentation

## 0.0.4

- Add support for `test` and `build` aliases
- Better and consistent error messages with an API

## 0.0.3+1

- Modify README to work correctly on pub.dev

## 0.0.3

- Add support for `--silent`
- Refactor Rust source code
- Start using derry for build
- Modify documentation

## 0.0.2

- Add support for subcommands

## 0.0.1

- Initial version, scaffolded by Stagehand
- Add support for list definitions
- Add support for configurable execution type
- Add support for win64, linux64, and (mac64)
- Add tests for helpers
