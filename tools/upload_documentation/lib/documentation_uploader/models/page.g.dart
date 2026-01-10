// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageImpl _$$PageImplFromJson(Map<String, dynamic> json) => _$PageImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      filePath: json['filePath'] as String,
      content: json['content'] as String,
      onlyAllowedUsers: (json['onlyAllowedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PageImplToJson(_$PageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'filePath': instance.filePath,
      'content': instance.content,
      'onlyAllowedUsers': instance.onlyAllowedUsers,
    };
