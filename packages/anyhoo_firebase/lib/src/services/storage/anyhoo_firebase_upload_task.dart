import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnyhooFirebaseUploadTask implements AnyhooUploadTask {
  final UploadTask uploadTask;

  AnyhooFirebaseUploadTask({required this.uploadTask});

  @override
  Future<String> getPath() async {
    final snapshot = uploadTask.snapshot;
    return snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> cancel() {
    return uploadTask.cancel();
  }

  @override
  int getBytesTransferred() {
    return uploadTask.snapshot.bytesTransferred;
  }

  @override
  int getTotalBytes() {
    return uploadTask.snapshot.totalBytes;
  }
}
