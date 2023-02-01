import 'package:derry/error.dart';
import 'package:derry/utils.dart';
import 'package:test/test.dart';

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

  group('Yaml file reading utilities', () {
    test("read_yaml_map should fail when there's not a file", () {
      expect(
        () async => readYamlMap('yaml'),
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
        () async => readYamlMap('README.md'),
        throwsA(isA<DerryError>()),
      );
    });
  });

  group('Pubspec class', () {
    // todo
  });

  group('ScriptsRegistry class', () {
    // todo
  });
}
