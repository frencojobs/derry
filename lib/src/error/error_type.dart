part of derry;

/// Error Types
///
/// Types of error that can be handled.
enum ErrorType {
  /// [SNF] = Script Not Found, throw when a particular script is not found
  snf,

  /// [DNF] = Definitions Not Found, throw when unable to locate definitions source

  dnf,

  /// [IET] = Incorrect Execution Type, throw when incorrect execution is configured

  iet,

  /// [CPD] = Cannot Parse Definitions, throw when definitions are configured in incorrected format

  cpd,

  /// [FNF] = File Not Found, throw when a specific file cannot be located

  fnf,

  /// [CPY] = Cannot Parse YAML, throw when YAML format is incorrect

  cpy,

  /// [CCT] = Cannot Cast Type, throw when a type can't be casted into another

  cct,

  /// [PNS] = Platform Not Supported, throw when using on an unsupported platform

  pns,
}
