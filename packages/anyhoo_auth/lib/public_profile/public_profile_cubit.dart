import 'package:anyhoo_auth/public_profile/public_profile.dart';
import 'package:anyhoo_auth/public_profile/public_profile_repository.dart';
import 'package:anyhoo_auth/public_profile/public_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Loads and publishes the signed-in user's public name and photo.
///
/// [publish] creates the document the first time this person shares something.
/// [updateIfPublished] changes it later and does nothing when they have never shared.
class PublicProfileCubit extends Cubit<PublicProfileState> {
  PublicProfileCubit({
    required this._repository,
    required this.userId,
  }) : super(const PublicProfileState());

  final PublicProfileRepository _repository;
  final String userId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final profile = await _repository.get(userId);
      emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          clearProfile: profile == null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> publish({
    required String displayName,
    required String photoUrl,
  }) {
    return _save(
      PublicProfile(id: userId, displayName: displayName, photoUrl: photoUrl),
    );
  }

  Future<void> updateIfPublished({
    required String displayName,
    required String photoUrl,
  }) async {
    final existing = state.profile ?? await _repository.get(userId);
    if (existing == null) {
      emit(state.copyWith(clearProfile: true, clearError: true));
      return;
    }
    await _save(
      existing.copyWith(displayName: displayName, photoUrl: photoUrl),
    );
  }

  Future<void> _save(PublicProfile profile) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.save(profile);
      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      rethrow;
    }
  }
}
