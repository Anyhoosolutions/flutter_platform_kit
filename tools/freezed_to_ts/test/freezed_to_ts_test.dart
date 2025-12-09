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
import type { Timestamp } from 'firebase/firestore';
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
import type { Timestamp } from 'firebase-admin/firestore';
import type { Address } from './address.ts';

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
import type { Timestamp } from 'firebase-admin/firestore';
import type { RecipeShort } from './recipe_short.ts';

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
      expect(userGroupResult, equals(expectedUserGroupTs), reason: 'UserGroup should include import for RecipeShort');

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
import type { Timestamp } from 'firebase/firestore';
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
  });
}
