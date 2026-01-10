// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toc_json_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TocJsonContentImpl _$$TocJsonContentImplFromJson(Map<String, dynamic> json) =>
    _$TocJsonContentImpl(
      filepath: json['filepath'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      subpages: (json['subpages'] as List<dynamic>)
          .map((e) => TocJsonContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      onlyAllowedUsers: json['onlyAllowedUsers'] as bool? ?? false,
    );

Map<String, dynamic> _$$TocJsonContentImplToJson(
        _$TocJsonContentImpl instance) =>
    <String, dynamic>{
      'filepath': instance.filepath,
      'name': instance.name,
      'title': instance.title,
      'subpages': instance.subpages,
      'onlyAllowedUsers': instance.onlyAllowedUsers,
    };
