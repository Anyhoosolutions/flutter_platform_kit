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
import { Timestamp } from 'firebase/firestore';
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
'''.trim();

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
            Address? shippingAddress,
          }) = _User;
        }
      ''';

      // Learn both classes
      converter.learn(addressCode);
      converter.learn(userCode);

      final expectedUserTs = r'''
export interface User {
  id: string;
  address: Address;
  shippingAddress: Address | null;
}
'''.trim();

      final expectedAddressTs = r'''
export interface Address {
  street: string;
  city: string;
}
'''.trim();


      final userResult = converter.convert(userCode).trim();
      expect(userResult, equals(expectedUserTs));

      final addressResult = converter.convert(addressCode).trim();
      expect(addressResult, equals(expectedAddressTs));
    });
  });
}