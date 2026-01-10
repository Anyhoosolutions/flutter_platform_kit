// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadDataImpl _$$UploadDataImplFromJson(Map<String, dynamic> json) =>
    _$UploadDataImpl(
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      pages: (json['pages'] as List<dynamic>)
          .map((e) => Page.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UploadDataImplToJson(_$UploadDataImpl instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'pages': instance.pages,
    };
