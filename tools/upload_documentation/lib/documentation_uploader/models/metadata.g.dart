// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetadataImpl _$$MetadataImplFromJson(Map<String, dynamic> json) =>
    _$MetadataImpl(
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      contactPerson:
          ContactPerson.fromJson(json['contactPerson'] as Map<String, dynamic>),
      projectImage: json['projectImage'] as String,
      tableOfContent: TableOfContent.fromJson(
          json['tableOfContent'] as Map<String, dynamic>),
      isBranch: json['isBranch'] as bool,
      allowedUsers: (json['allowedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$MetadataImplToJson(_$MetadataImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'contactPerson': instance.contactPerson,
      'projectImage': instance.projectImage,
      'tableOfContent': instance.tableOfContent,
      'isBranch': instance.isBranch,
      'allowedUsers': instance.allowedUsers,
    };
