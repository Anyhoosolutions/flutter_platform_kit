// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toc_json_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TocJsonContent _$TocJsonContentFromJson(Map<String, dynamic> json) {
  return _TocJsonContent.fromJson(json);
}

/// @nodoc
mixin _$TocJsonContent {
  String get filepath => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<TocJsonContent> get subpages => throw _privateConstructorUsedError;
  bool get onlyAllowedUsers => throw _privateConstructorUsedError;

  /// Serializes this TocJsonContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TocJsonContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TocJsonContentCopyWith<TocJsonContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TocJsonContentCopyWith<$Res> {
  factory $TocJsonContentCopyWith(
          TocJsonContent value, $Res Function(TocJsonContent) then) =
      _$TocJsonContentCopyWithImpl<$Res, TocJsonContent>;
  @useResult
  $Res call(
      {String filepath,
      String name,
      String title,
      List<TocJsonContent> subpages,
      bool onlyAllowedUsers});
}

/// @nodoc
class _$TocJsonContentCopyWithImpl<$Res, $Val extends TocJsonContent>
    implements $TocJsonContentCopyWith<$Res> {
  _$TocJsonContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TocJsonContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filepath = null,
    Object? name = null,
    Object? title = null,
    Object? subpages = null,
    Object? onlyAllowedUsers = null,
  }) {
    return _then(_value.copyWith(
      filepath: null == filepath
          ? _value.filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subpages: null == subpages
          ? _value.subpages
          : subpages // ignore: cast_nullable_to_non_nullable
              as List<TocJsonContent>,
      onlyAllowedUsers: null == onlyAllowedUsers
          ? _value.onlyAllowedUsers
          : onlyAllowedUsers // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TocJsonContentImplCopyWith<$Res>
    implements $TocJsonContentCopyWith<$Res> {
  factory _$$TocJsonContentImplCopyWith(_$TocJsonContentImpl value,
          $Res Function(_$TocJsonContentImpl) then) =
      __$$TocJsonContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String filepath,
      String name,
      String title,
      List<TocJsonContent> subpages,
      bool onlyAllowedUsers});
}

/// @nodoc
class __$$TocJsonContentImplCopyWithImpl<$Res>
    extends _$TocJsonContentCopyWithImpl<$Res, _$TocJsonContentImpl>
    implements _$$TocJsonContentImplCopyWith<$Res> {
  __$$TocJsonContentImplCopyWithImpl(
      _$TocJsonContentImpl _value, $Res Function(_$TocJsonContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TocJsonContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filepath = null,
    Object? name = null,
    Object? title = null,
    Object? subpages = null,
    Object? onlyAllowedUsers = null,
  }) {
    return _then(_$TocJsonContentImpl(
      filepath: null == filepath
          ? _value.filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subpages: null == subpages
          ? _value._subpages
          : subpages // ignore: cast_nullable_to_non_nullable
              as List<TocJsonContent>,
      onlyAllowedUsers: null == onlyAllowedUsers
          ? _value.onlyAllowedUsers
          : onlyAllowedUsers // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TocJsonContentImpl implements _TocJsonContent {
  _$TocJsonContentImpl(
      {required this.filepath,
      required this.name,
      required this.title,
      required final List<TocJsonContent> subpages,
      this.onlyAllowedUsers = false})
      : _subpages = subpages;

  factory _$TocJsonContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TocJsonContentImplFromJson(json);

  @override
  final String filepath;
  @override
  final String name;
  @override
  final String title;
  final List<TocJsonContent> _subpages;
  @override
  List<TocJsonContent> get subpages {
    if (_subpages is EqualUnmodifiableListView) return _subpages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subpages);
  }

  @override
  @JsonKey()
  final bool onlyAllowedUsers;

  @override
  String toString() {
    return 'TocJsonContent(filepath: $filepath, name: $name, title: $title, subpages: $subpages, onlyAllowedUsers: $onlyAllowedUsers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TocJsonContentImpl &&
            (identical(other.filepath, filepath) ||
                other.filepath == filepath) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._subpages, _subpages) &&
            (identical(other.onlyAllowedUsers, onlyAllowedUsers) ||
                other.onlyAllowedUsers == onlyAllowedUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, filepath, name, title,
      const DeepCollectionEquality().hash(_subpages), onlyAllowedUsers);

  /// Create a copy of TocJsonContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TocJsonContentImplCopyWith<_$TocJsonContentImpl> get copyWith =>
      __$$TocJsonContentImplCopyWithImpl<_$TocJsonContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TocJsonContentImplToJson(
      this,
    );
  }
}

abstract class _TocJsonContent implements TocJsonContent {
  factory _TocJsonContent(
      {required final String filepath,
      required final String name,
      required final String title,
      required final List<TocJsonContent> subpages,
      final bool onlyAllowedUsers}) = _$TocJsonContentImpl;

  factory _TocJsonContent.fromJson(Map<String, dynamic> json) =
      _$TocJsonContentImpl.fromJson;

  @override
  String get filepath;
  @override
  String get name;
  @override
  String get title;
  @override
  List<TocJsonContent> get subpages;
  @override
  bool get onlyAllowedUsers;

  /// Create a copy of TocJsonContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TocJsonContentImplCopyWith<_$TocJsonContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
