import 'package:test/test.dart';
import 'package:freezed_to_ts/converter.dart';

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

      final expectedTsCode = r'''
import { Timestamp } from 'firebase/firestore';
export interface User {
  id: string;
  email: string;
  fullName: string | null;
  age: number;
  rating: number;
  isPremium: boolean;
  createdAt: Timestamp;
  lastLogin: Timestamp | null;
  tags: string[];
  settings: { [key: string]: any };
}
'''.trim();

      final result = convertFreezedToTypeScript(dartCode).trim();
      
      expect(result, equals(expectedTsCode));
    });
  });
}
