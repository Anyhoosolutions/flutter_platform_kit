// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

part 'arguments.freezed.dart';

final _log = Logger('Arguments');

@freezed
sealed class Arguments with _$Arguments {
  const factory Arguments({
    // @Default(false) bool useTestDb,
    @Default(false) bool useFakeData,
    @Default(false) bool useDeviceEmulator,
    @Default(null) DateTime? currentTime,
    @Default(null) String? location,
    @Default(false) bool logoutAtStartup,
    @Default(false) bool loginAtStartup,
    @Default(null) String? userEmail,
    @Default(null) String? userPassword,
    bool? useFirebaseEmulator,
  }) = _Arguments;

  // ignore: unused_element
  const Arguments._();

  bool shouldUseFirebaseEmulator() {
    _log.info('!! useFirebaseEmulator: $useFirebaseEmulator');
    if (useFirebaseEmulator != null) {
      return useFirebaseEmulator!;
    }
    _log.info('!! kDebugMode: $kDebugMode');
    final isEnabled = (kDebugMode);
    return isEnabled;
  }
}
