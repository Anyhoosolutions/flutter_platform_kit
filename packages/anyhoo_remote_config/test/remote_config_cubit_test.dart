import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('replaces values with a new instance after setup', () async {
    final service = FakeAnyhooRemoteConfigService(
      values: const {'flag': 'true'},
    );
    final initial = const _FlagConfig(flag: false);
    final cubit = RemoteConfigCubit<_FlagConfig>(
      service: service,
      initialValues: initial,
    );

    await cubit.stream.first;

    expect(cubit.state.values.flag, isTrue);
    expect(identical(cubit.state.values, initial), isFalse);

    await cubit.close();
  });

  test('emits when the fake service pushes an update', () async {
    final service = FakeAnyhooRemoteConfigService(
      values: const {'flag': 'false'},
    );
    final cubit = RemoteConfigCubit<_FlagConfig>(
      service: service,
      initialValues: const _FlagConfig(flag: false),
    );

    await Future<void>.delayed(Duration.zero);
    service.update(const {'flag': 'true'});

    final next = await cubit.stream.first;
    expect(next.values.flag, isTrue);

    await cubit.close();
    service.update(const {'flag': 'false'});
  });

  test('does not emit when the parsed values are unchanged', () async {
    final service = FakeAnyhooRemoteConfigService(
      values: const {'flag': 'false'},
    );
    final cubit = RemoteConfigCubit<_FlagConfig>(
      service: service,
      initialValues: const _FlagConfig(flag: false),
    );
    final emissions = <RemoteConfigState<_FlagConfig>>[];
    final subscription = cubit.stream.listen(emissions.add);

    await Future<void>.delayed(Duration.zero);
    service.update(const {'flag': 'false'});
    await Future<void>.delayed(Duration.zero);

    expect(emissions, isEmpty);

    await subscription.cancel();
    await cubit.close();
  });
}

class _FlagConfig implements AnyhooRemoteConfigValues<_FlagConfig> {
  const _FlagConfig({required this.flag});

  final bool flag;

  @override
  _FlagConfig withMap(Map<String, dynamic> map) {
    final raw = map['flag'];
    return _FlagConfig(flag: raw == true || raw == 'true');
  }

  @override
  Map<String, dynamic> toMap() => {'flag': flag};
}
