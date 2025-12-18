import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
import 'package:anyhoo_auth/services/anyhoo_enhance_user_service.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final _log = Logger('AnyhooFirebaseEnhanceUserService');

class AnyhooFirebaseEnhanceUserService<T extends AnyhooUser> extends AnyhooEnhanceUserService<T> {
  AnyhooFirebaseEnhanceUserService(
      {required this.path, required this.firestore, required AnyhooUserConverter<T> converter})
      : _converter = converter;

  final String path;
  final FirebaseFirestore firestore;
  final AnyhooUserConverter<T> _converter;
  @override
  Future<T> enhanceUser(T user) async {
    final id = user.toJson()['id'];
    _log.info('Enhancing user (id): $id');
    _log.info('user values:');
    for (var entry in user.toJson().entries) {
      _log.info('user value: ${entry.key}: ${entry.value}');
    }

    if (id.isEmpty) {
      throw Exception('User map must contain either "id" or "uid" field');
    }
    final data = await firestore.collection(path).doc(id).get().then((value) => value.data() ?? <String, dynamic>{});

    final allFields = {...data, ...user.toJson()};
    final enhancedUser = _converter.fromJson(allFields);
    _log.info('Enhanced user: $enhancedUser');
    return enhancedUser;
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
