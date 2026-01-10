import 'package:freezed_annotation/freezed_annotation.dart';

part 'page.freezed.dart';
part 'page.g.dart';

@freezed
class Page with _$Page {
  factory Page({
    required String id,
    required String name,
    required String title,
    required String filePath,
    required String content,
    required List<String>? onlyAllowedUsers,
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
