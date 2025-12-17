import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';

class RemoteConfigValues extends AnyhooRemoteConfigValues {
  Map<String, String> values = {};

  @override
  void fromMap(Map<String, dynamic> map) {
    values.clear();
    values.addAll(map.cast<String, String>());
  }

  @override
  Map<String, dynamic> toMap() {
    return values.cast<String, dynamic>();
  }

  @override
  String toString() {
    return 'RemoteConfigValues(values: $values)';
  }
}
