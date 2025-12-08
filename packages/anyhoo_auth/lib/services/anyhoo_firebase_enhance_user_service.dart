import 'package:anyhoo_auth/services/anyhoo_enhance_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final _log = Logger('AnyhooFirebaseEnhanceUserService');

class AnyhooFirebaseEnhanceUserService extends AnyhooEnhanceUserService {
  AnyhooFirebaseEnhanceUserService({required this.path, required this.firestore});

  final String path;
  final FirebaseFirestore firestore;

  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    final id = user['id'] ?? user['uid'] ?? '';
    _log.info('Enhancing user (id): $id');
    _log.info('user values:');
    for (var entry in user.entries) {
      _log.info('user value: ${entry.key}: ${entry.value}');
    }

    if (id.isEmpty) {
      throw Exception('User map must contain either "id" or "uid" field');
    }
    final data = await firestore.collection(path).doc(id).get().then((value) => value.data() ?? <String, dynamic>{});

    final enhancedUser = {...data, ...user};
    _log.info('Enhanced user: $enhancedUser');
    return enhancedUser;
  }

  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    final id = user['id'] ?? user['uid'] ?? '';
    _log.info('Saving user (id): $id');
    _log.info('user values: ${user.entries}');

    if (id.isEmpty) {
      throw Exception('User map must contain either "id" or "uid" field');
    }

    await firestore.collection(path).doc(id).set(user);
  }
}
