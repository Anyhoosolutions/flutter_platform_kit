import 'package:freezed_annotation/freezed_annotation.dart';

part 'toc_json_content.freezed.dart';
part 'toc_json_content.g.dart';

@freezed
class TocJsonContent with _$TocJsonContent {
  factory TocJsonContent({
    required String filepath,
    required String name,
    required String title,
    required List<TocJsonContent> subpages,
    @Default(false) bool onlyAllowedUsers,
  }) = _TocJsonContent;

  factory TocJsonContent.fromJson(Map<String, dynamic> json) =>
      _$TocJsonContentFromJson(json);
}
