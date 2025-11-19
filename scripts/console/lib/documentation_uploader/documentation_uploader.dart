import 'file_reader.dart';
import 'models/upload_data.dart';
import 'uploader.dart';

class DocumentationUploader {
  DocumentationUploader({required this.isBranch, required this.commitHash})
      : fileReader = FileReader(
          isBranch: isBranch,
          commitHash: commitHash,
        );

  FileReader fileReader;
  final bool isBranch;
  final String? commitHash;

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
