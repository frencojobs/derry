part of derry;

/// Error Types
///
/// Types of error that can be handled.
enum ErrorType {
  /// [SNF] = Script Not Found, throw when a particular script is not found
  SNF,

  /// [DNF] = Definitions Not Found, throw when unable to locate definitions source

  DNF,

  /// [IET] = Incorrect Execution Type, throw when incorrect execution is configured

  IET,

  /// [CPD] = Cannot Parse Definitions, throw when definitions are configured in incorrected format

  CPD,

  /// [FNF] = File Not Found, throw when a specific file cannot be located

  FNF,

  /// [CPY] = Cannot Parse YAML, throw when YAML format is incorrect

  CPY,

  /// [CCT] = Cannot Cast Type, throw when a type can't be casted into another

  CCT,

  /// [PNS] = Platform Not Supported, throw when using on an unsupported platform

  PNS,
}
