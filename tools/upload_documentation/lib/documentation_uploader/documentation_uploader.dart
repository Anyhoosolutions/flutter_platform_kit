import 'package:upload_documentation/documentation_uploader/file_reader.dart';
import 'package:upload_documentation/documentation_uploader/models/upload_data.dart';
import 'package:upload_documentation/documentation_uploader/uploader.dart';

class DocumentationUploader {
  DocumentationUploader({
    required this.isBranch,
    required this.commitHash,
    required this.projectRoot,
  }) : fileReader = FileReader(
          isBranch: isBranch,
          commitHash: commitHash,
          projectRoot: projectRoot,
        );

  FileReader fileReader;
  final bool isBranch;
  final String? commitHash;
  final String projectRoot;

  Future<void> upload() async {
    final allowedUsers = await fileReader.readAllowedUsers();
    final tableOfContent = await fileReader.readTableOfContent(allowedUsers);
    final metadata = await fileReader.readMetadata(tableOfContent);
    final pages = await fileReader.readPages(tableOfContent);

    final uploadData = UploadData(metadata: metadata, pages: pages);
    final uploader = Uploader(uploadData: uploadData);
    await uploader.upload();
  }
}
