import 'package:anyhoo_auth/public_profile/public_profile.dart';

abstract class PublicProfileRepository {
  Future<PublicProfile?> get(String userId);

  Stream<PublicProfile?> watch(String userId);

  Future<void> save(PublicProfile profile);
}
