// ignore_for_file: unused_import, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    required int age,
    required double rating,
    required bool isPremium,
    required DateTime createdAt,
    DateTime? lastLogin,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> settings,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
