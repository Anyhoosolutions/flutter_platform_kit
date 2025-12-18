// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleUser _$ExampleUserFromJson(Map<String, dynamic> json) => _ExampleUser(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String?,
  phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExampleUserToJson(_ExampleUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
    };
