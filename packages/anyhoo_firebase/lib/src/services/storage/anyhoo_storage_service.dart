import 'dart:typed_data';

import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';

abstract class AnyhooStorageService {
  AnyhooUploadTask uploadFile(String path, String file);
  AnyhooUploadTask uploadFileFromBytes(String path, Uint8List bytes);
  Future<String> getDownloadUrl(String path);
  Future<void> deleteFile(String path);
}
