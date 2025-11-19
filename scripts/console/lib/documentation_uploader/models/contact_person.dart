import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_person.freezed.dart';
part 'contact_person.g.dart';

@freezed
class ContactPerson with _$ContactPerson {
  factory ContactPerson({
    required String name,
    required String email,
  }) = _ContactPerson;

  factory ContactPerson.fromJson(Map<String, dynamic> json) =>
      _$ContactPersonFromJson(json);
}
