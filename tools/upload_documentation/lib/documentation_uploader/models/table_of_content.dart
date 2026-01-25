import 'package:upload_documentation/documentation_uploader/models/toc_json_content.dart';
import 'package:upload_documentation/documentation_uploader/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_of_content.freezed.dart';
part 'table_of_content.g.dart';

@freezed
class TableOfContent with _$TableOfContent {
  const TableOfContent._();

  factory TableOfContent({
    required String id,
    required String tocTitle,
    required String pageTitle,
    required String filepath,
    required List<TableOfContent> subpages,
    @Default(null) List<String>? onlyAllowedUsers,
  }) = _TableOfContent;

  factory TableOfContent.fromJson(Map<String, dynamic> json) => _$TableOfContentFromJson(json);

  static TableOfContent fromTocJsonContent(TocJsonContent toc, List<String>? allowedUsers) {
    return TableOfContent(
      id: Utils.sanitizeFilepathForId(toc.filepath),
      tocTitle: toc.name,
      pageTitle: toc.title,
      filepath: toc.filepath,
      onlyAllowedUsers: toc.onlyAllowedUsers ? allowedUsers : null,
      subpages: toc.subpages.map((page) => fromTocJsonContent(page, allowedUsers)).toList(),
    );
  }
}
