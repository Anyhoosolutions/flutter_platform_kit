import 'package:anyhoo_auth/public_profile/public_profile.dart';
import 'package:anyhoo_auth/public_profile/public_profile_cubit.dart';
import 'package:anyhoo_auth/public_profile/public_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('load leaves the profile empty until it is published', () async {
    final repository = _MemoryPublicProfileRepository();
    final cubit = PublicProfileCubit(repository: repository, userId: 'user-1');
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state.profile, isNull);
    expect(cubit.state.isLoading, isFalse);
  });

  test('publish creates the public profile', () async {
    final repository = _MemoryPublicProfileRepository();
    final cubit = PublicProfileCubit(repository: repository, userId: 'user-1');
    addTearDown(cubit.close);

    await cubit.publish(
      displayName: 'Ada',
      photoUrl: 'https://example.com/ada.png',
    );

    expect(cubit.state.profile?.displayName, 'Ada');
    expect(
      repository.profiles['user-1']?.toJson().containsKey('email'),
      isFalse,
    );
  });

  test('updateIfPublished does nothing before the first share', () async {
    final repository = _MemoryPublicProfileRepository();
    final cubit = PublicProfileCubit(repository: repository, userId: 'user-1');
    addTearDown(cubit.close);

    await cubit.updateIfPublished(displayName: 'Ada', photoUrl: '');

    expect(repository.profiles.containsKey('user-1'), isFalse);
  });

  test(
    'updateIfPublished changes a profile that was already published',
    () async {
      final repository = _MemoryPublicProfileRepository()
        ..profiles['user-1'] = const PublicProfile(
          id: 'user-1',
          displayName: 'Ada',
          photoUrl: '',
        );
      final cubit = PublicProfileCubit(
        repository: repository,
        userId: 'user-1',
      );
      addTearDown(cubit.close);

      await cubit.updateIfPublished(displayName: 'Countess', photoUrl: '');

      expect(repository.profiles['user-1']?.displayName, 'Countess');
    },
  );
}

class _MemoryPublicProfileRepository implements PublicProfileRepository {
  final profiles = <String, PublicProfile>{};

  @override
  Future<PublicProfile?> get(String userId) async => profiles[userId];

  @override
  Future<void> save(PublicProfile profile) async {
    profiles[profile.id] = profile;
  }

  @override
  Stream<PublicProfile?> watch(String userId) => Stream.value(profiles[userId]);
}
