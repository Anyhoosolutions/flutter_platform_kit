import 'dart:io';
import 'dart:typed_data';

import 'package:anyhoo_firebase/src/services/storage/anyhoo_fake_upload_task.dart';
import 'package:anyhoo_firebase/src/services/storage/anyhoo_storage_service.dart';
import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';

class AnyhooFakeStorageService implements AnyhooStorageService {
  @override
  Future<void> deleteFile(String path) {
    return Future.value();
  }

  @override
  Future<String> getDownloadUrl(String path) {
    return Future.value('fake_path');
  }

  @override
  AnyhooUploadTask uploadFile(String path, File file) {
    return AnyhooFakeUploadTask();
  }

  @override
  AnyhooUploadTask uploadFileFromBytes(String path, Uint8List bytes, {String? mimeType}) {
    return AnyhooFakeUploadTask();
  }
}
