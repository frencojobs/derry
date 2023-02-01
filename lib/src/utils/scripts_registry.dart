import 'package:derry/bindings.dart' as bindings;
import 'package:derry/error.dart' show DerryError, ErrorCode;
import 'package:derry/utils.dart'
    show JsonMap, JsonMapExtension, Reference, Definition, referencePrefix, scriptsDefinitionKey;

/// Join a list of [String] with Space as delimiter.
String _joinStrings(List<String> list) => list.map((s) => s.trim()).join(' ');

/// A class that holds scripts and provides utilities
/// to work with them.
class ScriptsRegistry {
  /// A map of scripts retrieved from `pubspec.yaml`.
  static JsonMap? scripts;

  /// Constructs a [ScriptsRegistry] from a [JsonMap].
  ScriptsRegistry(JsonMap scriptsMap) {
    scripts ??= scriptsMap;
  }

  /// A list of all possible paths,
  /// used as a mean of memoization.
  static List<String>? paths;

  /// Returns all valid paths to access values from the scripts map.
  List<String> getPaths() {
    return paths ??= scripts!.getPaths();
  }

  /// Previous search results,
  /// used as a mean of memoization.
  static Map<String, dynamic> searchResults = {};

  /// Searches for a given path in the scripts map.
  dynamic lookup(String path) {
    return searchResults[path] ??= scripts!.lookup(path);
  }

  /// Previously serialized definitions,
  /// used as a mean of memoization.
  static Map<String, Definition> serializedDefinitions = {};

  /// Get a serialized [Definition] for a script string if it exists.
  /// This function will throw errors if the script is not defined
  /// or if the script is not valid.
  Definition getDefinition(String scriptString) {
    if (!serializedDefinitions.containsKey(scriptString)) {
      final scriptFound = lookup(scriptString);

      /// for when script is not defined at all
      if (scriptFound == null) {
        throw DerryError(
          type: ErrorCode.scriptNotDefined,
          body: {
            'script': scriptString,
            'suggestions': getPaths(),
          },
        );
      }

      if (scriptFound is Map) {
        final scripts = scriptFound[scriptsDefinitionKey];
        final validity = scripts != null && (scripts is List || scripts is String);

        if (!validity) {
          throw DerryError(
            type: ErrorCode.invalidScript,
            body: {'script': scriptString, 'paths': getPaths()},
          );
        }
      }

      serializedDefinitions[scriptString] = Definition.from(scriptFound);
    }

    return serializedDefinitions[scriptString]!;
  }

  /// Previously constructed references,
  /// used as a mean of memoization.
  static Map<String, Reference> references = {};

  /// Compute [Reference] parts from a script string.
  Reference getReference(String scriptString) {
    return references[scriptString] ??= Reference.from(scriptString);
  }

  /// Runs a script from the scripts map if it exists.
  Future<int> runScript(String script, {String extra = ''}) async {
    final preScript = lookup('pre$script');
    if (preScript != null) await _runScript('pre$script');

    final exitCode = _runScript(script, extra: extra);

    final postScript = lookup('post$script');
    if (postScript != null) await _runScript('post$script');

    return exitCode;
  }

  Future<int> _runScript(String scriptString, {String extra = ''}) async {
    final definition = getDefinition(scriptString);
    var exitCode = 0;

    for (final script in definition.scripts) {
      if (script.startsWith(referencePrefix)) {
        final ref = getReference(script);
        exitCode = await runScript(
          ref.script,
          extra: _joinStrings([ref.extra, extra]),
        );
      } else {
        // replace all \$ with $, they are not valid references
        final normalizedScript = script.replaceAll('\\$referencePrefix', referencePrefix);
        exitCode = await bindings.runScript(_joinStrings([normalizedScript, extra]));
      }
    }

    return exitCode;
  }
}
