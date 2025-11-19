// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_of_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableOfContentImpl _$$TableOfContentImplFromJson(Map<String, dynamic> json) =>
    _$TableOfContentImpl(
      id: json['id'] as String,
      tocTitle: json['tocTitle'] as String,
      pageTitle: json['pageTitle'] as String,
      filepath: json['filepath'] as String,
      subpages: (json['subpages'] as List<dynamic>)
          .map((e) => TableOfContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      onlyAllowedUsers: (json['onlyAllowedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          null,
    );

Map<String, dynamic> _$$TableOfContentImplToJson(
        _$TableOfContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tocTitle': instance.tocTitle,
      'pageTitle': instance.pageTitle,
      'filepath': instance.filepath,
      'subpages': instance.subpages,
      'onlyAllowedUsers': instance.onlyAllowedUsers,
    };
