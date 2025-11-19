import 'package:console/documentation_uploader/documentation_uploader.dart';

Future<void> main(List<String> arguments) async {
  String? commitHash;
  final isBranch = arguments.any((a) => a.startsWith('--commitHash='));
  if (isBranch) {
    commitHash = arguments
        .where((a) => a.startsWith('--commitHash='))
        .first
        .split('=')[1];
  }
  final documentationUploader = DocumentationUploader(
    isBranch: isBranch,
    commitHash: commitHash,
  );
  await documentationUploader.upload();
}
