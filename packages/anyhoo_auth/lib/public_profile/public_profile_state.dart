import 'package:anyhoo_auth/public_profile/public_profile.dart';

class PublicProfileState {
  const PublicProfileState({
    this.isLoading = false,
    this.profile,
    this.errorMessage,
  });

  final bool isLoading;

  /// Null when this person has not published a public profile.
  final PublicProfile? profile;
  final String? errorMessage;

  PublicProfileState copyWith({
    bool? isLoading,
    PublicProfile? profile,
    String? errorMessage,
    bool clearProfile = false,
    bool clearError = false,
  }) {
    return PublicProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : profile ?? this.profile,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
