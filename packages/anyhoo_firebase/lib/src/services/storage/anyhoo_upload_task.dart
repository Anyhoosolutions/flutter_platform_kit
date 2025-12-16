abstract class AnyhooUploadTask {
  Future<void> cancel();
  Future<String> getDownloadUrl();
  bool isComplete();
  Stream<int> getBytesTransferred();
}
