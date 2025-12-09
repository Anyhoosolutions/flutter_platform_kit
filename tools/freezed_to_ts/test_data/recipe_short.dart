import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_short.freezed.dart';
part 'recipe_short.g.dart';

@freezed
sealed class RecipeShort with _$RecipeShort {
  const factory RecipeShort({
    required String id,
    required String title,
    @Default(null) String? description,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> categories,
  }) = _RecipeShort;

  factory RecipeShort.fromJson(Map<String, Object?> json) =>
      _$RecipeShortFromJson(json);
}
