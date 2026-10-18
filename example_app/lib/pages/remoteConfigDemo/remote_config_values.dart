import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';

class RemoteConfigValues
    extends AnyhooRemoteConfigValues<RemoteConfigValues> {
  RemoteConfigValues([Map<String, String>? values]) : values = {...?values};

  final Map<String, String> values;

  @override
  RemoteConfigValues withMap(Map<String, dynamic> map) {
    return RemoteConfigValues(
      map.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.from(values);
  }

  @override
  String toString() {
    return 'RemoteConfigValues(values: $values)';
  }
}
