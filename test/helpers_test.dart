import 'dart:io';

import 'package:test/test.dart';
import 'package:derry/derry.dart';
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
        equals(Info(name: 'derry', version: '0.0.3+1')),
      );
    });

    test('parse_definition should return expected outputs', () {
      expect(
        parseDefinitions('echo 0'),
        equals(Definition(execution: 'multiple', scripts: ['echo 0'])),
      );
    });

    test('read_pubspec should return correct outputs', () async {
      expect(
        (await readPubspec()).contents.value['name'],
        equals('derry'),
      );
    });

    test('read_yaml_file should fail when there\'s not a file', () {
      expect(
        () async => await readYamlFile('yaml'),
        throwsA(
          equals(
            Error(
              type: ErrorType.FNF,
              body: {'path': 'yaml'},
            ),
          ),
        ),
      );
    });

    test('read_yaml_file should fail when the file is not in yaml format', () {
      expect(
        () async => await readYamlFile('README.md'),
        throwsA(
          equals(
            Error(type: ErrorType.CPY),
          ),
        ),
      );
    });

    test('to_list should throw an error on incorrect type', () {
      expect(
        () => toList(null),
        throwsA(
          equals(
            Error(
              type: ErrorType.CCT,
              body: {'from': Null, 'to': 'List<String>'},
            ),
          ),
        ),
      );
    });

    test('sub_command should parse correctly', () {
      expect(
        subcommand('\$prep'),
        equals('prep'),
      );

      expect(
        subcommand('\\\$prep'),
        equals(''),
      );
    });
  });
}
