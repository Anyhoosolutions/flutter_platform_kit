import 'dart:io';

import 'package:args/args.dart';
import 'package:freezed_to_ts/copy_shared_models_to_docs.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'input',
      abbr: 'i',
      help: 'Path to a Dart file or directory containing shared model Dart files (e.g. lib/sharedModels).',
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Path to the output Markdown documentation file (e.g. docs/shared_models.md).',
    );

  final results = parser.parse(arguments);

  if (!results.wasParsed('input')) {
    // ignore: avoid_print
    print('Usage: dart run freezed_to_ts:copy_shared_models_to_docs -i <input_path> [-o <output_path>]');
    // ignore: avoid_print
    print(parser.usage);
    exit(1);
  }

  final inputPath = results['input'] as String;
  final outputPath = results['output'] as String?;

  final input = File(inputPath);
  final inputDir = Directory(inputPath);

  if (!input.existsSync() && !inputDir.existsSync()) {
    // ignore: avoid_print
    print('Error: Input not found at $inputPath');
    exit(1);
  }

  final copier = CopySharedModelsToDocs();
  final markdown = copier.generate(inputPath);

  if (outputPath != null) {
    final out = File(outputPath);
    out.parent.createSync(recursive: true);
    out.writeAsStringSync(markdown);
    // ignore: avoid_print
    print('Wrote ${p.canonicalize(out.path)}');
  } else {
    // ignore: avoid_print
    print(markdown);
  }
}
