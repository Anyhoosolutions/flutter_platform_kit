import 'dart:io';
import 'package:upload_documentation/documentation_uploader/documentation_uploader.dart';

Future<void> main(List<String> arguments) async {
  String? commitHash;
  String? projectRoot;

  final isBranch = arguments.any((a) => a.startsWith('--commitHash='));
  if (isBranch) {
    commitHash = arguments.where((a) => a.startsWith('--commitHash=')).first.split('=')[1];
  }

  // Get project root from argument or use current working directory
  final projectRootArg = arguments.where((a) => a.startsWith('--projectRoot=')).firstOrNull;
  if (projectRootArg != null) {
    projectRoot = projectRootArg.split('=')[1];
  } else {
    // Default: assume we're running from the repository root
    // or from tools/upload_documentation directory, so docs is at ../../docs
    projectRoot = Directory.current.path;
  }

  final documentationUploader = DocumentationUploader(
    isBranch: isBranch,
    commitHash: commitHash,
    projectRoot: projectRoot,
  );
  await documentationUploader.upload();
}
