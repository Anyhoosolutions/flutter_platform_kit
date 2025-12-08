import 'package:args/args.dart';
import 'dart:io';
import 'package:freezed_to_ts/freezed_to_ts.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('path', abbr: 'p', help: 'Path to the Dart file with freezed classes.');
  final argResults = parser.parse(arguments);

  if (!argResults.wasParsed('path')) {
    print('Usage: dart run freezed_to_ts --path <file_path.dart>');
    print(parser.usage);
    exit(1);
  }

  final filePath = argResults['path'] as String;
  final file = File(filePath);

  if (!await file.exists()) {
    print('Error: File not found at $filePath');
    exit(1);
  }

  final content = await file.readAsString();
  final result = convertFreezedToTypeScript(content);
  print(result);
}
