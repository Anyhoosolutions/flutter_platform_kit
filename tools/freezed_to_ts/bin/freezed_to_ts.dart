import 'package:args/args.dart';
import 'dart:io';
import 'package:freezed_to_ts/freezed_to_ts.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  Logger.root.level = Level.INFO;

  Logger.root.onRecord.listen((record) {
    final str = '${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}';
    // ignore: avoid_print
    print('LOG: $str');
  });

  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to a Dart file or a directory containing Dart files.')
    ..addOption('output', abbr: 'o', help: 'Directory where the generated TypeScript files will be written.');

  final argResults = parser.parse(arguments);

  if (!argResults.wasParsed('input')) {
    print('Usage: dart run freezed_to_ts -i <file_or_directory_path> [-o <output_directory_path>]');
    print(parser.usage);
    exit(1);
  }

  final inputPath = argResults['input'] as String;
  final outputPath = argResults['output'] as String?;

  final type = FileSystemEntity.typeSync(inputPath);

  if (type == FileSystemEntityType.notFound) {
    print('Error: Input not found at $inputPath');
    exit(1);
  }

  final filesToProcess = <File>[];
  if (type == FileSystemEntityType.file) {
    if (inputPath.endsWith('.dart')) {
      filesToProcess.add(File(inputPath));
    }
  } else if (type == FileSystemEntityType.directory) {
    final dir = Directory(inputPath);
    final files = dir.listSync(recursive: true);
    for (final file in files) {
      if (file is File && file.path.endsWith('.dart')) {
        filesToProcess.add(file);
      }
    }
  }
  if (filesToProcess.isEmpty) {
    print('No Dart files found to process.');
    return;
  }

  final converter = FreezedToTsConverter();
  for (final file in filesToProcess) {
    final content = await file.readAsString();
    if (content.contains('@freezed')) {
      converter.learn(content);
    }
  }

  for (final file in filesToProcess) {
    await _processFile(file, outputPath, converter);
  }
}

Future<void> _processFile(
  File file,
  String? outputDir,
  FreezedToTsConverter converter,
) async {
  final content = await file.readAsString();
  if (!content.contains('@freezed')) return;

  print('Processing ${file.path}...');
  final tsContent = converter.convert(content);

  if (tsContent.isEmpty) {
    print('  -> No freezed classes found.');
    return;
  }

  if (outputDir != null) {
    final outputFileName = p.basenameWithoutExtension(file.path) + '.ts';
    final outputFile = File(p.join(outputDir, outputFileName));

    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(tsContent);
    print('  -> Wrote to ${outputFile.path}');
  } else {
    print('---\n${file.path}:\n---\n$tsContent');
  }
}
