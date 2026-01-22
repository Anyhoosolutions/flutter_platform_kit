import 'dart:io';
import 'dart:typed_data';

import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';

abstract class AnyhooStorageService {
  AnyhooUploadTask uploadFile(String path, File file);
  AnyhooUploadTask uploadFileFromBytes(
    String path,
    Uint8List bytes, {
    String? mimeType,
  });
  Future<String> getDownloadUrl(String path);
  Future<void> deleteFile(String path);
}
