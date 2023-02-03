import 'dart:io' show File, Directory, IOOverrides;

import 'package:derry/error.dart';
import 'package:derry/utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<File>(), MockSpec<Directory>()])
import './utils_test.mocks.dart';

void main() {
  test("Definition's from factory should work", () {
    expect(
      Definition.from('echo 0'),
      equals(const Definition(scripts: ['echo 0'])),
    );

    expect(
      Definition.from(const ['echo 0', 'echo 1']),
      equals(const Definition(scripts: ['echo 0', 'echo 1'])),
    );

    expect(
      Definition.from(const {
        '(description)': 'A description',
        '(scripts)': ['echo 0', 'echo 1'],
      }),
      equals(
        const Definition(
          description: 'A description',
          scripts: ['echo 0', 'echo 1'],
        ),
      ),
    );
  });

  test("Info's toString should work", () {
    expect(
      const Info(name: 'derry', version: '0.0.1').toString(),
      equals('derry@0.0.1'),
    );
  });

  group("JsonMap's lookup function", () {
    final jsonmap = {
      'foo': {'bar': 'baz'}
    };

    test('lookup should return the correct value for a valid path', () {
      expect(
        jsonmap.lookup('foo bar'),
        equals('baz'),
      );
    });

    test('lookup should return null for an invalid path', () {
      expect(
        jsonmap.lookup('foo baz'),
        isNull,
      );
    });

    test('lookup should also be able to return maps', () {
      expect(
        jsonmap.lookup('foo'),
        equals({'bar': 'baz'}),
      );
    });
  });

  group("JsonMap's getPaths function", () {
    test('getPaths should return all valid paths with string scripts', () {
      final jsonmap = {
        'foo': {
          'bar': 'baz',
          'baz': 'bar',
        },
        'bar': 'foo',
      };

      expect(
        jsonmap.getPaths(),
        equals(['foo bar', 'foo baz', 'bar']),
      );
    });

    test('getPaths should return all valid paths with array of scripts', () {
      final jsonmap = {
        'foo': {
          'bar': ['baz', 'bar'],
          'baz': [],
          'buzz': ['foo'],
        },
        'bar': 'foo',
      };

      expect(
        jsonmap.getPaths(),
        equals(['foo bar', 'foo baz', 'foo buzz', 'bar']),
      );
    });

    test('getPaths should return all valid paths even when deeply nested', () {
      final jsonmap = {
        'foo': {
          'bar': {
            'baz': {
              'bar': 'foo',
              'baz': [],
            },
          },
        },
        'bar': 'foo',
      };

      expect(
        jsonmap.getPaths(),
        equals(['foo bar baz bar', 'foo bar baz baz', 'bar']),
      );
    });

    test('getPaths should ignore keys with parenthesis', () {
      final jsonmap = {
        'foo': {
          '(bar)': 'baz',
          '(baz)': 'bar',
        },
        'bar': 'foo',
      };

      expect(
        jsonmap.getPaths(),
        equals(['foo', 'bar']),
      );
    });
  });

  // grouping a bunch of tests didn't work with IOOverrides
  // therefore we have a big test instead
  test('Pubspec class', () {
    final mockFile = MockFile();
    final mockDirectory = MockDirectory();
    final mockCurrentDirectory = MockDirectory();

    IOOverrides.runZoned(
      () async {
        final pubspec = Pubspec();

        // filePath
        when(mockCurrentDirectory.path).thenReturn("current-directory-path");
        expect(Pubspec.filePath, equals(path.join("current-directory-path", pubspecFileName)));

        // content
        const mockPubspecContent = """
name: test
version: 0.0.0""";
        const mockPubspecMap = {"name": "test", "version": "0.0.0"};
        when(mockFile.exists()).thenAnswer((_) => Future.value(true));
        when(mockFile.readAsString()).thenAnswer((_) => Future.value(mockPubspecContent));

        expect(Pubspec.content, equals(null));
        expect(
          await pubspec.getContent(),
          equals(mockPubspecMap),
        );
        expect(Pubspec.content, mockPubspecMap);

        // getInfo
        expect(
          await pubspec.getInfo(),
          Info(
            name: mockPubspecMap["name"],
            version: mockPubspecMap["version"],
          ),
        );

        // getSource
        // if scripts field is null
        expect(Pubspec.source, equals(null));
        expect(
          pubspec.getSource(),
          throwsA(equals(DerryError(type: ErrorCode.missingScripts))),
        );

        await Future.delayed(const Duration(seconds: 1));

        // if scripts field is of a type other than Map or String
        Pubspec.content![scriptsKey] = 0;
        expect(
          pubspec.getSource(),
          throwsA(equals(DerryError(type: ErrorCode.invalidScript))),
        );

        await Future.delayed(const Duration(seconds: 1));

        // if scripts field is a Map
        expect(Pubspec.source, equals(null));
        Pubspec.content![scriptsKey] = {};
        expect(
          await pubspec.getSource(),
          equals(pubspecFileName),
        );
        expect(Pubspec.source, pubspecFileName);

        // if scripts field is a string
        Pubspec.source = null;
        Pubspec.content![scriptsKey] = "derry.yaml";
        expect(
          await pubspec.getSource(),
          equals("derry.yaml"),
        );
        expect(Pubspec.source, "derry.yaml");

        // getScripts
        expect(Pubspec.scripts, equals(null));

        // if scripts field is a map
        Pubspec.scripts = null;
        Pubspec.source = pubspecFileName;
        expect(await pubspec.getScripts(), equals({}));
        expect(Pubspec.scripts, equals({}));

        // if scripts field is a string aka a file path
        Pubspec.scripts = null;
        Pubspec.source = "derry.yaml";

        const mockScriptsFile = """
a: b
c: 
  - d
  - e""";
        final mockScriptsMap = {
          "a": "b",
          "c": ["d", "e"]
        };
        when(mockFile.exists()).thenAnswer((_) => Future.value(true));
        when(mockFile.readAsString()).thenAnswer((_) => Future.value(mockScriptsFile));

        expect(await pubspec.getScripts(), equals(mockScriptsMap));
        expect(Pubspec.scripts, equals(mockScriptsMap));
      },
      getCurrentDirectory: () => mockCurrentDirectory,
      createDirectory: (path) => mockDirectory,
      createFile: (path) => mockFile,
    );
  });

  group('Yaml file reading utilities', () {
    test("read_yaml_map should fail when there's not a file", () {
      expect(
        readYamlMap('yaml'),
        throwsA(
          equals(
            DerryError(
              type: ErrorCode.fileNotFound,
              body: {'path': 'yaml'},
            ),
          ),
        ),
      );
    });

    test('read_yaml_map should fail when the file is not in yaml format', () {
      expect(
        readYamlMap('README.md'),
        throwsA(isA<DerryError>()),
      );
    });
  });

  test("Reference's from factory should work", () {
    expect(
      Reference.from("\$script_a"),
      equals(
        const Reference(script: "script_a", extra: ""),
      ),
    );

    expect(
      Reference.from("\$script_a --extra extra"),
      equals(
        const Reference(script: "script_a", extra: "--extra extra"),
      ),
    );

    expect(
      Reference.from("\$script_a:script_b"),
      equals(
        const Reference(script: "script_a script_b", extra: ""),
      ),
    );
    expect(
      Reference.from("\$script_a:script_b --extra extra"),
      equals(
        const Reference(script: "script_a script_b", extra: "--extra extra"),
      ),
    );
  });

  group('ScriptsRegistry class', () {
    late ScriptsRegistry registry;
    final sampleScriptsMap = {"script_a": "a"};

    test(
      "constructor works",
      () {
        expect(ScriptsRegistry.scripts, equals(null));
        registry = ScriptsRegistry(sampleScriptsMap);
        expect(ScriptsRegistry.scripts, equals(sampleScriptsMap));
      },
    );

    test("getPaths memoization works", () {
      expect(ScriptsRegistry.paths, equals(null));
      expect(registry.getPaths(), equals(["script_a"]));
      expect(ScriptsRegistry.paths, equals(["script_a"]));
    });

    test("lookup memoization works", () {
      expect(ScriptsRegistry.searchResults, equals({}));
      expect(registry.lookup("script_a"), equals(sampleScriptsMap["script_a"]));
      expect(ScriptsRegistry.searchResults, equals(sampleScriptsMap));
    });

    test("getDefinition memoization works", () {
      expect(ScriptsRegistry.serializedDefinitions, equals({}));
      expect(
        registry.getDefinition("script_a"),
        equals(
          Definition.from(sampleScriptsMap["script_a"]),
        ),
      );
      expect(
        ScriptsRegistry.serializedDefinitions["script_a"],
        equals(Definition.from(sampleScriptsMap["script_a"])),
      );
    });

    test("getDefinition errors throw", () {
      // when script doesn't exist at all
      expect(
        () async => registry.getDefinition("script_b"),
        throwsA(
          equals(
            DerryError(
              type: ErrorCode.scriptNotDefined,
              body: {'script': "script_b", 'suggestions': registry.getPaths()},
            ),
          ),
        ),
      );

      // when script exist but of invalid type
      ScriptsRegistry.scripts = {"script_c": 0}; // force update for test
      expect(
        () async => registry.getDefinition("script_c"),
        throwsA(
          equals(
            DerryError(
              type: ErrorCode.invalidScript,
              body: {'script': "script_c"},
            ),
          ),
        ),
      );
      ScriptsRegistry.scripts = sampleScriptsMap; // reset

      // when script is valid but the map it points to is invalid
      // when (scripts) is null
      ScriptsRegistry.scripts = {"script_d": {}}; // force update for test
      expect(
        () async => registry.getDefinition("script_d"),
        throwsA(
          equals(
            DerryError(
              type: ErrorCode.invalidScript,
              body: {'script': "script_d", 'paths': registry.getPaths()},
            ),
          ),
        ),
      );

      // when (scripts) is not a List or String
      ScriptsRegistry.scripts = {
        "script_e": {
          [scriptsDefinitionKey]: 0
        }
      }; // force update for test
      expect(
        () async => registry.getDefinition("script_e"),
        throwsA(
          equals(
            DerryError(
              type: ErrorCode.invalidScript,
              body: {'script': "script_e", 'paths': registry.getPaths()},
            ),
          ),
        ),
      );

      ScriptsRegistry.scripts = sampleScriptsMap; // reset
    });

    test("getReference memoization works", () {
      expect(ScriptsRegistry.references, equals({}));
      expect(
        registry.getReference("\$script_a"),
        equals(Reference.from("\$script_a")),
      );
      expect(
        ScriptsRegistry.references["\$script_a"],
        equals(Reference.from("\$script_a")),
      );
    });

    // todo: to add tests for runScript
  });
}
