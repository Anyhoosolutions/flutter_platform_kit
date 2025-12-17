import 'package:freezed_to_ts/freezed_to_ts.dart';
import 'package:test/test.dart';

void main() {
  group('Freezed to TypeScript Converter', () {
    test('converts a complex freezed class correctly', () {
      const dartCode = r'''
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
      ''';

      final converter = FreezedToTsConverter();
      converter.learn(dartCode);
      final result = converter.convert(dartCode).trim();

      final expectedTsCode = r'''
import type { Timestamp } from "firebase-admin/firestore";
export interface User {
  id: string;
  email: string;
  full_name: string | null;
  age: number;
  rating: number;
  isPremium: boolean;
  createdAt: Timestamp;
  lastLogin: Timestamp | null;
  tags: string[];
  settings: { [key: string]: any };
}
'''
          .trim();

      expect(result, equals(expectedTsCode));
    });

    test('handles nested freezed classes', () {
      final converter = FreezedToTsConverter();

      const addressCode = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';
        
        part 'address.freezed.dart';
        
        @freezed
        class Address with _$Address {
          const factory Address({
            required String street,
            required String city,
          }) = _Address;
        }
      ''';

      const userCode = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'address.dart';
        
        part 'user.freezed.dart';
        
        @freezed
        class User with _$User {
          const factory User({
            required String id,
            required Address address,
            DateTime? createdAt,
          }) = _User;
        }
      ''';

      // Learn both classes
      converter.learn(addressCode);
      converter.learn(userCode);

      final expectedUserTs = r'''
import type { Timestamp } from "firebase-admin/firestore";
import type { Address } from "./address.ts";

export interface User {
  id: string;
  address: Address;
  createdAt: Timestamp | null;
}
'''
          .trim();

      final expectedAddressTs = r'''
export interface Address {
  street: string;
  city: string;
}
'''
          .trim();

      final userResult = converter.convert(userCode).trim();
      expect(userResult, equals(expectedUserTs));

      final addressResult = converter.convert(addressCode).trim();
      expect(addressResult, equals(expectedAddressTs));
    });

    test('handles nested freezed classes with package imports', () {
      final converter = FreezedToTsConverter();

      const recipeShortCode = r'''
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
      ''';

      const userGroupCode = r'''
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
      ''';

      // Learn both classes
      converter.learn(recipeShortCode);
      converter.learn(userGroupCode);

      final expectedUserGroupTs = r'''
import type { Timestamp } from "firebase-admin/firestore";
import type { RecipeShort } from "./recipe_short.ts";

export interface UserGroup {
  id: string;
  groupRef: string | null;
  title: string;
  description: string | null;
  createdAt: Timestamp;
  updatedAt: Timestamp;
  recipes: RecipeShort[];
}
'''
          .trim();

      final expectedRecipeShortTs = r'''
export interface RecipeShort {
  id: string;
  title: string;
  description: string | null;
  imageUrls: string[];
  categories: string[];
}
'''
          .trim();

      final userGroupResult = converter.convert(userGroupCode).trim();
      expect(userGroupResult, equals(expectedUserGroupTs),
          reason: 'UserGroup should include import for RecipeShort');

      final recipeShortResult = converter.convert(recipeShortCode).trim();
      expect(recipeShortResult, equals(expectedRecipeShortTs));
    });

    test('handles JsonKey with fromJson/toJson conversion functions', () {
      const dartCode = r'''
        import 'package:cloud_firestore/cloud_firestore.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';

        part 'task.freezed.dart';
        part 'task.g.dart';

        DateTime fromDateTime(Timestamp dateTime) => dateTime.toDate();
        Timestamp toDateTime(DateTime dateTime) => Timestamp.fromDate(dateTime);

        DateTime? fromMaybeDateTime(Timestamp? dateTime) => dateTime?.toDate();
        Timestamp? toMaybeDateTime(DateTime? dateTime) =>
            dateTime != null ? Timestamp.fromDate(dateTime) : null;

        @freezed
        abstract class Task with _$Task {
          const factory Task.simple({
            @Default(null) String? id,
            required String name,
            required String createdBy,
            required bool private,
            @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
            required DateTime createdAt,

            @JsonKey(fromJson: fromMaybeDateTime, toJson: toMaybeDateTime)
            required DateTime? updatedAt,
          }) = SimpleTask;

          factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
        }
      ''';

      final converter = FreezedToTsConverter();
      converter.learn(dartCode);
      final result = converter.convert(dartCode).trim();

      final expectedTsCode = r'''
import type { Timestamp } from "firebase-admin/firestore";
export interface Task {
  id: string | null;
  name: string;
  createdBy: string;
  private: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp | null;
}
'''
          .trim();

      expect(result, equals(expectedTsCode));
    });

    test('handles enums with package imports', () {
      final converter = FreezedToTsConverter();

      const themeTypeCode = r'''
        enum ThemeType {
          light,
          dark,
          system,
        }
      ''';

      const userProfileCode = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'package:snapandsavor/features/profile/theme_type.dart';

        part 'user_profile.freezed.dart';
        part 'user_profile.g.dart';

        @freezed
        sealed class UserProfile with _$UserProfile {
          const factory UserProfile({
            required String id,
            required String name,
            required ThemeType theme,
            ThemeType? preferredTheme,
          }) = _UserProfile;

          factory UserProfile.fromJson(Map<String, Object?> json) =>
              _$UserProfileFromJson(json);
        }
      ''';

      // Learn both enum and class
      converter.learn(themeTypeCode);
      converter.learn(userProfileCode);

      final expectedThemeTypeTs = r'''
export enum ThemeType {
  light = "light",
  dark = "dark",
  system = "system",
}
'''
          .trim();

      final expectedUserProfileTs = r'''
import type { ThemeType } from "./theme_type.ts";

export interface UserProfile {
  id: string;
  name: string;
  theme: ThemeType;
  preferredTheme: ThemeType | null;
}
'''
          .trim();

      final themeTypeResult = converter.convert(themeTypeCode).trim();
      expect(themeTypeResult, equals(expectedThemeTypeTs),
          reason: 'ThemeType enum should be converted to TypeScript enum');

      final userProfileResult = converter.convert(userProfileCode).trim();
      expect(userProfileResult, equals(expectedUserProfileTs),
          reason: 'UserProfile should include import for ThemeType enum');
    });

    test('validates full file output with enum and freezed class in same file',
        () {
      final converter = FreezedToTsConverter();

      const fullFileCode = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';

        part 'user_settings.freezed.dart';
        part 'user_settings.g.dart';

        enum ThemeType {
          light,
          dark,
          system,
        }

        @freezed
        sealed class UserSettings with _$UserSettings {
          const factory UserSettings({
            required String id,
            required ThemeType theme,
            ThemeType? preferredTheme,
          }) = _UserSettings;

          factory UserSettings.fromJson(Map<String, Object?> json) =>
              _$UserSettingsFromJson(json);
        }
      ''';

      converter.learn(fullFileCode);

      final expectedFullFileTs = r'''
export enum ThemeType {
  light = "light",
  dark = "dark",
  system = "system",
}

export interface UserSettings {
  id: string;
  theme: ThemeType;
  preferredTheme: ThemeType | null;
}
'''
          .trim();

      final result = converter.convert(fullFileCode).trim();
      expect(result, equals(expectedFullFileTs),
          reason:
              'Full file should output enum and interface without importing enum from elsewhere');
    });

    test('validates full file output with multiple enums and freezed classes',
        () {
      final converter = FreezedToTsConverter();

      const fullFileCode = r'''
        import 'package:cloud_firestore/cloud_firestore.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';

        part 'models.freezed.dart';
        part 'models.g.dart';

        enum Status {
          active,
          inactive,
          pending,
        }

        enum Priority {
          low,
          medium,
          high,
        }

        DateTime fromDateTime(Timestamp dateTime) => dateTime.toDate();
        Timestamp toDateTime(DateTime dateTime) => Timestamp.fromDate(dateTime);

        @freezed
        sealed class Task with _$Task {
          const factory Task({
            required String id,
            required String title,
            required Status status,
            required Priority priority,
            @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
            required DateTime createdAt,
          }) = _Task;

          factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
        }

        @freezed
        sealed class Project with _$Project {
          const factory Project({
            required String id,
            required String name,
            required List<Task> tasks,
            Status? currentStatus,
          }) = _Project;

          factory Project.fromJson(Map<String, Object?> json) => _$ProjectFromJson(json);
        }
      ''';

      converter.learn(fullFileCode);

      final expectedFullFileTs = r'''
import type { Timestamp } from "firebase-admin/firestore";

export enum Priority {
  low = "low",
  medium = "medium",
  high = "high",
}

export enum Status {
  active = "active",
  inactive = "inactive",
  pending = "pending",
}

export interface Project {
  id: string;
  name: string;
  tasks: Task[];
  currentStatus: Status | null;
}

export interface Task {
  id: string;
  title: string;
  status: Status;
  priority: Priority;
  createdAt: Timestamp;
}
'''
          .trim();

      final result = converter.convert(fullFileCode).trim();
      expect(result, equals(expectedFullFileTs),
          reason:
              'Full file should output all enums and interfaces in correct order without duplicate imports');
    });

    test(
        'validates multiple input files generate correct multiple output files',
        () {
      final converter = FreezedToTsConverter();

      // File 1: Enum definition
      const themeTypeFile = r'''
        enum ThemeType {
          light,
          dark,
          system,
        }
      ''';

      // File 2: Freezed class that uses other file
      const userProfileFile = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'settings.dart';

        part 'user_profile.freezed.dart';
        part 'user_profile.g.dart';

        @freezed
        sealed class UserProfile with _$UserProfile {
          const factory UserProfile({
            required String id,
            required String name,
            required Settings settings,
          }) = _UserProfile;

          factory UserProfile.fromJson(Map<String, Object?> json) =>
              _$UserProfileFromJson(json);
        }
      ''';

      // File 3: Another freezed class that uses the enum
      const settingsFile = r'''
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'package:snapandsavor/features/profile/theme_type.dart';

        part 'settings.freezed.dart';
        part 'settings.g.dart';

        @freezed
        sealed class Settings with _$Settings {
          const factory Settings({
            required String userId,
            required ThemeType defaultTheme,
            @Default([]) List<ThemeType> allowedThemes,
          }) = _Settings;

          factory Settings.fromJson(Map<String, Object?> json) =>
              _$SettingsFromJson(json);
        }
      ''';

      // Learn all files
      converter.learn(themeTypeFile);
      converter.learn(userProfileFile);
      converter.learn(settingsFile);

      // Expected outputs
      final expectedThemeTypeOutput = r'''
export enum ThemeType {
  light = "light",
  dark = "dark",
  system = "system",
}
'''
          .trim();

      final expectedUserProfileOutput = r'''
import type { Settings } from "./settings.ts";

export interface UserProfile {
  id: string;
  name: string;
  settings: Settings;
}
'''
          .trim();

      final expectedSettingsOutput = r'''
import type { ThemeType } from "./theme_type.ts";

export interface Settings {
  userId: string;
  defaultTheme: ThemeType;
  allowedThemes: ThemeType[];
}
'''
          .trim();

      // Convert each file and validate output
      final themeTypeResult = converter.convert(themeTypeFile).trim();
      expect(themeTypeResult, equals(expectedThemeTypeOutput),
          reason: 'ThemeType file should output enum definition');

      final userProfileResult = converter.convert(userProfileFile).trim();
      expect(userProfileResult, equals(expectedUserProfileOutput),
          reason: 'UserProfile file should output interface with enum import');

      final settingsResult = converter.convert(settingsFile).trim();
      expect(settingsResult, equals(expectedSettingsOutput),
          reason: 'Settings file should output interface with enum import');
    });

    test('validates parse text files', () {
      final converter = FreezedToTsConverter();

      // File 1: Freezed class that is referenced by other files
      const uploadInfoFile = r'''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_info.freezed.dart';
part 'upload_info.g.dart';

enum RecipeUploadType { image, web, youtube, instagram, manually }

@freezed
sealed class UploadInfo with _$UploadInfo {
  const factory UploadInfo({
    required RecipeUploadType type,
    @Default(null) String? source,
  }) = _UploadInfo;

  factory UploadInfo.fromJson(Map<String, Object?> json) =>
      _$UploadInfoFromJson(json);
}
''';

      // File 2: Freezed class that uses other file
      const parseTextFile = r'''
        // ignore_for_file: invalid_annotation_target

        import 'package:cloud_firestore/cloud_firestore.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'package:snapandsavor/sharedModels/upload_info.dart';

        part 'parse_text.freezed.dart';
        part 'parse_text.g.dart';

        enum ParsingTextStatus { completed, parsingText, error }

        @freezed
        abstract class ParseText with _$ParseText {
          const factory ParseText({
            required String groupId,
            required String? recipeId,
            required String userId,
            @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
            required DateTime createdAt,
            @JsonKey(fromJson: fromMaybeDateTime, toJson: toMaybeDateTime)
            required DateTime? processedAt,
            required String? text,
            required String? error,
            required RecipeUploadType type,
            required String uploadRef,
            required String status,
            required String source,
          }) = _ParseText;

          factory ParseText.fromJson(Map<String, Object?> json) =>
              _$ParseTextFromJson(json);
        }

        DateTime fromDateTime(Timestamp dateTime) => dateTime.toDate();
        Timestamp toDateTime(DateTime dateTime) => Timestamp.fromDate(dateTime);

        DateTime? fromMaybeDateTime(Timestamp? dateTime) => dateTime?.toDate();
        Timestamp? toMaybeDateTime(DateTime? dateTime) =>
            dateTime != null ? Timestamp.fromDate(dateTime) : null;

      ''';

      // File 3: Another freezed class that uses the enum
      const parseDataForRecipeFile = r'''
        // ignore_for_file: invalid_annotation_target

        import 'package:cloud_firestore/cloud_firestore.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';
        import 'package:snapandsavor/sharedModels/upload_info.dart';

        part 'parsing_data_for_recipe.freezed.dart';
        part 'parsing_data_for_recipe.g.dart';

        enum ParsingDataForRecipeStatus {
          uploaded,
          parsingSource,
          buildingRecipe,
          completed,
          error,
        }

        // TODO: Different factories instead?
        @freezed
        sealed class ParsingDataForRecipe with _$ParsingDataForRecipe {
          const factory ParsingDataForRecipe({
            required String? id,
            required String uploadId,
            required String source,
            required RecipeUploadType recipeUploadType,
            required String groupId,
            required ParsingDataForRecipeStatus status,
            required String userId,
            @JsonKey(fromJson: fromDateTime, toJson: toDateTime)
            required DateTime createdAt,
            String? recipeId,
            @JsonKey(fromJson: fromMaybeDateTime, toJson: toMaybeDateTime)
            DateTime? processedAt,
            String? output,
            String? error,
          }) = _ParsingDataForRecipe;

          factory ParsingDataForRecipe.fromJson(Map<String, Object?> json) =>
              _$ParsingDataForRecipeFromJson(json);
        }

        DateTime fromDateTime(Timestamp dateTime) => dateTime.toDate();
        Timestamp toDateTime(DateTime dateTime) => Timestamp.fromDate(dateTime);

        DateTime? fromMaybeDateTime(Timestamp? dateTime) => dateTime?.toDate();
        Timestamp? toMaybeDateTime(DateTime? dateTime) =>
            dateTime != null ? Timestamp.fromDate(dateTime) : null;

      ''';

      // Learn all files
      converter.learn(uploadInfoFile);
      converter.learn(parseTextFile);
      converter.learn(parseDataForRecipeFile);

      final expectedUploadInfoTextOutput = r'''
export enum RecipeUploadType {
  image = "image",
  web = "web",
  youtube = "youtube",
  instagram = "instagram",
  manually = "manually",
}

export interface UploadInfo {
  type: RecipeUploadType;
  source: string | null;
}''';

      final expectedParseTextOutput = r'''
import type { Timestamp } from "firebase-admin/firestore";
import type { RecipeUploadType } from "./upload_info";

export enum ParsingTextStatus {
  completed = "completed",
  parsingText = "parsingText",
  error = "error",
}

export interface ParseText {
  groupId: string;
  recipeId: string | null;
  userId: string;
  createdAt: Timestamp;
  processedAt: Timestamp | null;
  text: string | null;
  error: string | null;
  type: RecipeUploadType;
  uploadRef: string;
  status: string;
  source: string;
}
'''
          .trim();

      final expectedParseDataForRecipeOutput = r'''
import type { Timestamp } from "firebase-admin/firestore";
import type { RecipeUploadType } from "./upload_info";

export enum ParsingDataForRecipeStatus {
  uploaded = "uploaded",
  parsingSource = "parsingSource",
  buildingRecipe = "buildingRecipe",
  completed = "completed",
  error = "error",
}

export interface ParsingDataForRecipe {
  id: string | null;
  uploadId: string;
  source: string;
  recipeUploadType: RecipeUploadType;
  groupId: string;
  status: ParsingDataForRecipeStatus;
  userId: string;
  createdAt: Timestamp;
  recipeId: string | null;
  processedAt: Timestamp | null;
  output: string | null;
  error: string | null;
}
'''
          .trim();

      // Convert each file and validate output

      final uploadInfoResult = converter.convert(uploadInfoFile).trim();
      expect(uploadInfoResult, equals(expectedUploadInfoTextOutput),
          reason: 'UploadInfo file should output interface with enum import');

      final parseTextResult = converter.convert(parseTextFile).trim();
      print(parseTextResult);
      expect(parseTextResult, equals(expectedParseTextOutput),
          reason: 'ParseText file should output interface with enum import');

      final parseDataForRecipeResult =
          converter.convert(parseDataForRecipeFile).trim();
      expect(parseDataForRecipeResult, equals(expectedParseDataForRecipeOutput),
          reason:
              'ParseDataForRecipe file should output interface with enum import');
    });
  });
}
