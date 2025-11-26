class CurrentTimeRepository {
  final DateTime? _currentTime;
  const CurrentTimeRepository(this._currentTime);

  DateTime getCurrentTime() {
    if (_currentTime != null) {
      return _currentTime;
    }

    return DateTime.now();
  }
}
