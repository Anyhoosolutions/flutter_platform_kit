/// Name and photo other signed-in people can read at `publicProfiles/{id}`.
class PublicProfile {
  const PublicProfile({
    required this.id,
    required this.displayName,
    required this.photoUrl,
  });

  static const collection = 'publicProfiles';

  final String id;
  final String displayName;
  final String photoUrl;

  PublicProfile copyWith({String? id, String? displayName, String? photoUrl}) {
    return PublicProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
    );
  }

  /// Fields stored on the document. The document id is the user id.
  Map<String, dynamic> toJson() {
    return {'displayName': displayName, 'photoUrl': photoUrl};
  }
}
