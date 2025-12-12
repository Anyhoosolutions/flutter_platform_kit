import 'package:freezed_annotation/freezed_annotation.dart';

part 'emulator_config.freezed.dart';

@freezed
abstract class EmulatorConfig with _$EmulatorConfig {
  factory EmulatorConfig({
    @Default('localhost') String host,
    @Default(null) String? hostIp,
    @Default(true) bool useDeviceEmulator,
    @Default(null) bool? overrideUseFirebaseEmulator,
    @Default(true) bool useFirebaseAuth,
    @Default(true) bool useFirebaseFirestore,
    @Default(true) bool useFirebaseStorage,
    @Default(9099) int authPort,
    @Default(8080) int firestorePort,
    @Default(9199) int storagePort,
  }) = _EmulatorConfig;
}
