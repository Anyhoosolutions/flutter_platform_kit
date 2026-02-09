import 'dart:io';
import 'dart:typed_data';

import 'package:anyhoo_firebase/src/services/storage/anyhoo_firebase_upload_task.dart';
import 'package:anyhoo_firebase/src/services/storage/anyhoo_storage_service.dart';
import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

final _log = Logger('AnyhooFirebaseStorageService');

class AnyhooFirebaseStorageService implements AnyhooStorageService {
  final FirebaseStorage storage;

  AnyhooFirebaseStorageService({required this.storage});

  @override
  Future<void> deleteFile(String path) {
    return storage.ref(path).delete();
  }

  @override
  Future<String> getDownloadUrl(String path) {
    return storage.ref(path).getDownloadURL();
  }

  @override
  AnyhooUploadTask uploadFile(String path, File file) {
    _log.info('!! Uploading file to $path');
    final uploadTask = storage.ref(path).putFile(file);
    return AnyhooFirebaseUploadTask(uploadTask: uploadTask);
  }

  @override
  AnyhooUploadTask uploadFileFromBytes(String path, Uint8List bytes, {String? mimeType}) {
    _log.info('!! Uploading file from bytes to $path with mime type $mimeType');
    late UploadTask uploadTask;
    if (mimeType == null) {
      uploadTask = storage.ref(path).putData(bytes);
    } else {
      uploadTask = storage.ref(path).putData(bytes, SettableMetadata(contentType: mimeType));
    }
    return AnyhooFirebaseUploadTask(uploadTask: uploadTask);
  }
}
