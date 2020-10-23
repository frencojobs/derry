import 'dart:io';

import 'package:test/test.dart';
import 'package:derry/derry.dart';
import 'package:derry/src/load_info.dart';
import 'package:derry/src/load_definitions.dart';
import 'package:derry/src/helpers/to_list.dart';
import 'package:derry/src/helpers/subcommand.dart';
import 'package:derry/src/helpers/make_keys.dart';
import 'package:derry/src/helpers/deep_search.dart';
import 'package:derry/src/helpers/read_pubspec.dart';
import 'package:derry/src/helpers/read_yaml_file.dart';
import 'package:derry/src/helpers/parse_defnintion.dart';
import 'package:yaml/yaml.dart' show loadYamlDocument;

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
            const Error(
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
            const Error(type: ErrorType.cpy),
          ),
        ),
      );
    });

    test('to_list should throw an error on incorrect type', () {
      expect(
        () => toList(null),
        throwsA(
          equals(
            const Error(
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
