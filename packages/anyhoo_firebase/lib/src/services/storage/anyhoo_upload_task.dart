abstract class AnyhooUploadTask {
  Future<void> cancel();
  Future<String> getPath();
  int getBytesTransferred();
  int getTotalBytes();
}
