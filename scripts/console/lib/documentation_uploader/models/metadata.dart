import 'package:console/documentation_uploader/models/contact_person.dart';
import 'package:console/documentation_uploader/models/table_of_content.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata.freezed.dart';
part 'metadata.g.dart';

@freezed
class Metadata with _$Metadata {
  factory Metadata({
    required String projectId,
    required String name,
    required String description,
    required ContactPerson contactPerson,
    required String projectImage,
    required TableOfContent tableOfContent,
    required bool isBranch,
    required List<String>? allowedUsers,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}
