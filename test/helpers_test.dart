import 'dart:io';

import 'package:derry/error.dart';
import 'package:derry/helpers.dart';
import 'package:derry/models.dart';
import 'package:derry/version.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Are helpers working? Because ', () {
    test('load_definitions should return correct scripts', () async {
      expect(
        await loadDefinitions(),
        loadYamlDocument(await File('derry.yaml').readAsString())
            .contents
            .value,
      );
    });

    test('load_info should return proper results', () async {
      expect(
        await loadInfo(),
        equals(const Info(name: 'derry', version: packageVersion)),
      );
    });

    test('parse_definition should return expected outputs', () {
      expect(
        parseDefinition('echo 0'),
        equals(const Definition(scripts: ['echo 0'])),
      );
    });

    test('read_pubspec should return correct outputs', () async {
      expect(
        (await readPubspec()).contents.value['name'],
        equals('derry'),
      );
    });

    test("read_yaml_file should fail when there's not a file", () {
      expect(
        () async => readYamlFile('yaml'),
        throwsA(
          equals(
            const DerryError(
              type: ErrorType.fnf,
              body: {'path': 'yaml'},
            ),
          ),
        ),
      );
    });

    test('read_yaml_file should fail when the file is not in yaml format', () {
      expect(
        () async => readYamlFile('README.md'),
        throwsA(
          equals(
            const DerryError(type: ErrorType.cpy),
          ),
        ),
      );
    });

    test('to_list should throw an error on incorrect type', () {
      expect(
        () => toList(null),
        throwsA(
          equals(
            const DerryError(
              type: ErrorType.cct,
              body: {
                'from': Null,
                'to': 'List<String>',
              },
            ),
          ),
        ),
      );
    });

    test('sub_command should parse correctly', () {
      expect(
        subcommand('\$prep'),
        equals({
          'command': 'prep',
          'extra': '',
        }),
      );

      expect(
        subcommand('\$dart --version'),
        equals({
          'command': 'dart',
          'extra': '--version',
        }),
      );

      expect(
        subcommand('\\\$prep'),
        equals({
          'command': '',
          'extra': '',
        }),
      );
    });
  });

  test('deep_search should work as expected', () {
    expect(
      search({
        'foo': {'bar': 'baz'}
      }, 'foo bar'),
      equals('baz'),
    );
  });

  test('make_keys should also work as expected', () {
    expect(
      makeKeys({
        'foo': {'bar': 'baz'},
        'far': 'feb'
      }),
      equals(['foo bar', 'far']),
    );
  });
}
