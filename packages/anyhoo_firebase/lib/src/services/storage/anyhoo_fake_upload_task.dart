import 'package:anyhoo_firebase/src/services/storage/anyhoo_upload_task.dart';

class AnyhooFakeUploadTask implements AnyhooUploadTask {
  @override
  bool isComplete() {
    return true;
  }

  @override
  Future<String> getDownloadUrl() {
    return Future.value('fake_path');
  }

  @override
  Future<void> cancel() {
    return Future.value();
  }

  @override
  int getBytesTransferred() {
    return 123;
  }

  @override
  int getTotalBytes() {
    return 1234;
  }
}
