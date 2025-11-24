import 'package:anyhoo_auth/services/enhance_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEnhanceUserService extends EnhanceUserService {
  FirebaseEnhanceUserService({required this.path, FirebaseFirestore? firestore})
      : super(enhanceUserFunction: _createEnhanceUserFunction(firestore ?? FirebaseFirestore.instance, path));

  final String path;

  static Future<Map<String, dynamic>> Function(Map<String, dynamic>) _createEnhanceUserFunction(
      FirebaseFirestore firestore, String path) {
    return (Map<String, dynamic> user) async {
      final id = user['id'] ?? user['uid'] ?? '';
      if (id.isEmpty) {
        throw Exception('User map must contain either "id" or "uid" field');
      }
      final data = await firestore.collection(path).doc(id).get().then((value) => value.data() ?? <String, dynamic>{});

      return data;
    };
  }
}
