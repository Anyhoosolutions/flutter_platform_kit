import 'dart:async';

import 'package:anyhoo_auth/services/anyhoo_enhance_user_service.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final _log = Logger('AnyhooFirebaseEnhanceUserService');

class AnyhooFirebaseEnhanceUserService<T extends AnyhooUser> extends AnyhooEnhanceUserService<T> {
  AnyhooFirebaseEnhanceUserService({required this.path, required this.firestore});

  final String path;
  final FirebaseFirestore firestore;

  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    final id = user['id'];
    _log.info('Enhancing user (id): $id');
    _log.info('user values:');
    for (var entry in user.entries) {
      _log.info('user value: ${entry.key}: ${entry.value}');
    }

    if (id.isEmpty) {
      throw Exception('User map must contain either "id" or "uid" field');
    }

    try {
      _log.info('Fetching user data from Firestore collection: $path');
      final snapshot = await firestore.collection(path).doc(id).get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _log.warning('Firestore read timed out for user $id, using empty data');
          final timeoutError = TimeoutException('Firestore read timed out', const Duration(seconds: 10));
          SentryHelper.captureException(timeoutError, fatal: false);
          throw timeoutError;
        },
      );

      final data = snapshot.data() ?? <String, dynamic>{};
      _log.info('Firestore data retrieved: $data');
      final enhancedUser = {...data, ...user};
      _log.info('Enhanced user: $enhancedUser');
      return enhancedUser;
    } catch (e, stackTrace) {
      _log.warning('Error enhancing user from Firestore (continuing with base user data): $e', e, stackTrace);
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      // Return user data without Firestore enhancement if there's an error
      return user;
    }
  }

  @override
  Future<T> saveUser(T user) async {
    final id = user.toJson()['id'];
    _log.info('Saving user (id): $id');
    _log.info('user values: ${user.toJson().entries}');

    if (id.isEmpty) {
      throw Exception('User map must contain either "id" or "uid" field');
    }

    await firestore.collection(path).doc(id).set(user.toJson());
    return user;
  }
}
