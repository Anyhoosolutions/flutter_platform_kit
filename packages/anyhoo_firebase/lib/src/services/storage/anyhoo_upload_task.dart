abstract class AnyhooUploadTask {
  Future<void> cancel();
  int getBytesTransferred();
  int getTotalBytes();
}
