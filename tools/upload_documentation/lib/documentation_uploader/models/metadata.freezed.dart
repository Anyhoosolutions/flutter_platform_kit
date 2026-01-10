// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  return _Metadata.fromJson(json);
}

/// @nodoc
mixin _$Metadata {
  String get projectId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ContactPerson get contactPerson => throw _privateConstructorUsedError;
  String get projectImage => throw _privateConstructorUsedError;
  TableOfContent get tableOfContent => throw _privateConstructorUsedError;
  bool get isBranch => throw _privateConstructorUsedError;
  List<String>? get allowedUsers => throw _privateConstructorUsedError;

  /// Serializes this Metadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataCopyWith<Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res, Metadata>;
  @useResult
  $Res call(
      {String projectId,
      String name,
      String description,
      ContactPerson contactPerson,
      String projectImage,
      TableOfContent tableOfContent,
      bool isBranch,
      List<String>? allowedUsers});

  $ContactPersonCopyWith<$Res> get contactPerson;
  $TableOfContentCopyWith<$Res> get tableOfContent;
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res, $Val extends Metadata>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? name = null,
    Object? description = null,
    Object? contactPerson = null,
    Object? projectImage = null,
    Object? tableOfContent = null,
    Object? isBranch = null,
    Object? allowedUsers = freezed,
  }) {
    return _then(_value.copyWith(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      contactPerson: null == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as ContactPerson,
      projectImage: null == projectImage
          ? _value.projectImage
          : projectImage // ignore: cast_nullable_to_non_nullable
              as String,
      tableOfContent: null == tableOfContent
          ? _value.tableOfContent
          : tableOfContent // ignore: cast_nullable_to_non_nullable
              as TableOfContent,
      isBranch: null == isBranch
          ? _value.isBranch
          : isBranch // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedUsers: freezed == allowedUsers
          ? _value.allowedUsers
          : allowedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactPersonCopyWith<$Res> get contactPerson {
    return $ContactPersonCopyWith<$Res>(_value.contactPerson, (value) {
      return _then(_value.copyWith(contactPerson: value) as $Val);
    });
  }

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TableOfContentCopyWith<$Res> get tableOfContent {
    return $TableOfContentCopyWith<$Res>(_value.tableOfContent, (value) {
      return _then(_value.copyWith(tableOfContent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MetadataImplCopyWith<$Res>
    implements $MetadataCopyWith<$Res> {
  factory _$$MetadataImplCopyWith(
          _$MetadataImpl value, $Res Function(_$MetadataImpl) then) =
      __$$MetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String projectId,
      String name,
      String description,
      ContactPerson contactPerson,
      String projectImage,
      TableOfContent tableOfContent,
      bool isBranch,
      List<String>? allowedUsers});

  @override
  $ContactPersonCopyWith<$Res> get contactPerson;
  @override
  $TableOfContentCopyWith<$Res> get tableOfContent;
}

/// @nodoc
class __$$MetadataImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$MetadataImpl>
    implements _$$MetadataImplCopyWith<$Res> {
  __$$MetadataImplCopyWithImpl(
      _$MetadataImpl _value, $Res Function(_$MetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? name = null,
    Object? description = null,
    Object? contactPerson = null,
    Object? projectImage = null,
    Object? tableOfContent = null,
    Object? isBranch = null,
    Object? allowedUsers = freezed,
  }) {
    return _then(_$MetadataImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      contactPerson: null == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as ContactPerson,
      projectImage: null == projectImage
          ? _value.projectImage
          : projectImage // ignore: cast_nullable_to_non_nullable
              as String,
      tableOfContent: null == tableOfContent
          ? _value.tableOfContent
          : tableOfContent // ignore: cast_nullable_to_non_nullable
              as TableOfContent,
      isBranch: null == isBranch
          ? _value.isBranch
          : isBranch // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedUsers: freezed == allowedUsers
          ? _value._allowedUsers
          : allowedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataImpl implements _Metadata {
  _$MetadataImpl(
      {required this.projectId,
      required this.name,
      required this.description,
      required this.contactPerson,
      required this.projectImage,
      required this.tableOfContent,
      required this.isBranch,
      required final List<String>? allowedUsers})
      : _allowedUsers = allowedUsers;

  factory _$MetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataImplFromJson(json);

  @override
  final String projectId;
  @override
  final String name;
  @override
  final String description;
  @override
  final ContactPerson contactPerson;
  @override
  final String projectImage;
  @override
  final TableOfContent tableOfContent;
  @override
  final bool isBranch;
  final List<String>? _allowedUsers;
  @override
  List<String>? get allowedUsers {
    final value = _allowedUsers;
    if (value == null) return null;
    if (_allowedUsers is EqualUnmodifiableListView) return _allowedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Metadata(projectId: $projectId, name: $name, description: $description, contactPerson: $contactPerson, projectImage: $projectImage, tableOfContent: $tableOfContent, isBranch: $isBranch, allowedUsers: $allowedUsers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            (identical(other.projectImage, projectImage) ||
                other.projectImage == projectImage) &&
            (identical(other.tableOfContent, tableOfContent) ||
                other.tableOfContent == tableOfContent) &&
            (identical(other.isBranch, isBranch) ||
                other.isBranch == isBranch) &&
            const DeepCollectionEquality()
                .equals(other._allowedUsers, _allowedUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      projectId,
      name,
      description,
      contactPerson,
      projectImage,
      tableOfContent,
      isBranch,
      const DeepCollectionEquality().hash(_allowedUsers));

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataImplCopyWith<_$MetadataImpl> get copyWith =>
      __$$MetadataImplCopyWithImpl<_$MetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataImplToJson(
      this,
    );
  }
}

abstract class _Metadata implements Metadata {
  factory _Metadata(
      {required final String projectId,
      required final String name,
      required final String description,
      required final ContactPerson contactPerson,
      required final String projectImage,
      required final TableOfContent tableOfContent,
      required final bool isBranch,
      required final List<String>? allowedUsers}) = _$MetadataImpl;

  factory _Metadata.fromJson(Map<String, dynamic> json) =
      _$MetadataImpl.fromJson;

  @override
  String get projectId;
  @override
  String get name;
  @override
  String get description;
  @override
  ContactPerson get contactPerson;
  @override
  String get projectImage;
  @override
  TableOfContent get tableOfContent;
  @override
  bool get isBranch;
  @override
  List<String>? get allowedUsers;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataImplCopyWith<_$MetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
