// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snapandsavor/sharedModels/recipe_short.dart';

part 'user_group.freezed.dart';
part 'user_group.g.dart';

@freezed
sealed class UserGroup with _$UserGroup {
  const factory UserGroup({
    required String id,
    @Default(null) String? groupRef,
    required String title,
    @Default(null) String? description,
    @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
    required DateTime createdAt,
    @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
    required DateTime updatedAt,
    @Default([]) List<RecipeShort> recipes,
  }) = _UserGroup;

  factory UserGroup.fromJson(Map<String, Object?> json) =>
      _$UserGroupFromJson(json);
}

DateTime fromDateTime(Timestamp dateTime) => dateTime.toDate();
Timestamp toDateTime(DateTime dateTime) => Timestamp.fromDate(dateTime);
