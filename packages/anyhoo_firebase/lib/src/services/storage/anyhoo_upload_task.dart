abstract class AnyhooUploadTask {
  Future<void> cancel();
  Future<String> getDownloadUrl();
  int getBytesTransferred();
  int getTotalBytes();
  bool isComplete();
}
