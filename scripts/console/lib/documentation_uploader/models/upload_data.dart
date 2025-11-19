import 'package:console/documentation_uploader/models/metadata.dart';
import 'package:console/documentation_uploader/models/page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_data.freezed.dart';
part 'upload_data.g.dart';

@freezed
class UploadData with _$UploadData {
  factory UploadData({
    required Metadata metadata,
    required List<Page> pages,
  }) = _UploadData;

  factory UploadData.fromJson(Map<String, dynamic> json) =>
      _$UploadDataFromJson(json);
}
