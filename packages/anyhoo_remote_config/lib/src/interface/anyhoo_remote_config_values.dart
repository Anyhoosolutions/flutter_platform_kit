abstract class AnyhooRemoteConfigValues<T extends AnyhooRemoteConfigValues<T>> {
  /// Return a new instance parsed from [map]. Do not mutate the receiver.
  T withMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}
