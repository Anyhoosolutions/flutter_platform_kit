// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_of_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TableOfContent _$TableOfContentFromJson(Map<String, dynamic> json) {
  return _TableOfContent.fromJson(json);
}

/// @nodoc
mixin _$TableOfContent {
  String get id => throw _privateConstructorUsedError;
  String get tocTitle => throw _privateConstructorUsedError;
  String get pageTitle => throw _privateConstructorUsedError;
  String get filepath => throw _privateConstructorUsedError;
  List<TableOfContent> get subpages => throw _privateConstructorUsedError;
  List<String>? get onlyAllowedUsers => throw _privateConstructorUsedError;

  /// Serializes this TableOfContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableOfContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableOfContentCopyWith<TableOfContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableOfContentCopyWith<$Res> {
  factory $TableOfContentCopyWith(
          TableOfContent value, $Res Function(TableOfContent) then) =
      _$TableOfContentCopyWithImpl<$Res, TableOfContent>;
  @useResult
  $Res call(
      {String id,
      String tocTitle,
      String pageTitle,
      String filepath,
      List<TableOfContent> subpages,
      List<String>? onlyAllowedUsers});
}

/// @nodoc
class _$TableOfContentCopyWithImpl<$Res, $Val extends TableOfContent>
    implements $TableOfContentCopyWith<$Res> {
  _$TableOfContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableOfContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tocTitle = null,
    Object? pageTitle = null,
    Object? filepath = null,
    Object? subpages = null,
    Object? onlyAllowedUsers = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tocTitle: null == tocTitle
          ? _value.tocTitle
          : tocTitle // ignore: cast_nullable_to_non_nullable
              as String,
      pageTitle: null == pageTitle
          ? _value.pageTitle
          : pageTitle // ignore: cast_nullable_to_non_nullable
              as String,
      filepath: null == filepath
          ? _value.filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as String,
      subpages: null == subpages
          ? _value.subpages
          : subpages // ignore: cast_nullable_to_non_nullable
              as List<TableOfContent>,
      onlyAllowedUsers: freezed == onlyAllowedUsers
          ? _value.onlyAllowedUsers
          : onlyAllowedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TableOfContentImplCopyWith<$Res>
    implements $TableOfContentCopyWith<$Res> {
  factory _$$TableOfContentImplCopyWith(_$TableOfContentImpl value,
          $Res Function(_$TableOfContentImpl) then) =
      __$$TableOfContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tocTitle,
      String pageTitle,
      String filepath,
      List<TableOfContent> subpages,
      List<String>? onlyAllowedUsers});
}

/// @nodoc
class __$$TableOfContentImplCopyWithImpl<$Res>
    extends _$TableOfContentCopyWithImpl<$Res, _$TableOfContentImpl>
    implements _$$TableOfContentImplCopyWith<$Res> {
  __$$TableOfContentImplCopyWithImpl(
      _$TableOfContentImpl _value, $Res Function(_$TableOfContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TableOfContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tocTitle = null,
    Object? pageTitle = null,
    Object? filepath = null,
    Object? subpages = null,
    Object? onlyAllowedUsers = freezed,
  }) {
    return _then(_$TableOfContentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tocTitle: null == tocTitle
          ? _value.tocTitle
          : tocTitle // ignore: cast_nullable_to_non_nullable
              as String,
      pageTitle: null == pageTitle
          ? _value.pageTitle
          : pageTitle // ignore: cast_nullable_to_non_nullable
              as String,
      filepath: null == filepath
          ? _value.filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as String,
      subpages: null == subpages
          ? _value._subpages
          : subpages // ignore: cast_nullable_to_non_nullable
              as List<TableOfContent>,
      onlyAllowedUsers: freezed == onlyAllowedUsers
          ? _value._onlyAllowedUsers
          : onlyAllowedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TableOfContentImpl extends _TableOfContent {
  _$TableOfContentImpl(
      {required this.id,
      required this.tocTitle,
      required this.pageTitle,
      required this.filepath,
      required final List<TableOfContent> subpages,
      final List<String>? onlyAllowedUsers = null})
      : _subpages = subpages,
        _onlyAllowedUsers = onlyAllowedUsers,
        super._();

  factory _$TableOfContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableOfContentImplFromJson(json);

  @override
  final String id;
  @override
  final String tocTitle;
  @override
  final String pageTitle;
  @override
  final String filepath;
  final List<TableOfContent> _subpages;
  @override
  List<TableOfContent> get subpages {
    if (_subpages is EqualUnmodifiableListView) return _subpages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subpages);
  }

  final List<String>? _onlyAllowedUsers;
  @override
  @JsonKey()
  List<String>? get onlyAllowedUsers {
    final value = _onlyAllowedUsers;
    if (value == null) return null;
    if (_onlyAllowedUsers is EqualUnmodifiableListView)
      return _onlyAllowedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TableOfContent(id: $id, tocTitle: $tocTitle, pageTitle: $pageTitle, filepath: $filepath, subpages: $subpages, onlyAllowedUsers: $onlyAllowedUsers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableOfContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tocTitle, tocTitle) ||
                other.tocTitle == tocTitle) &&
            (identical(other.pageTitle, pageTitle) ||
                other.pageTitle == pageTitle) &&
            (identical(other.filepath, filepath) ||
                other.filepath == filepath) &&
            const DeepCollectionEquality().equals(other._subpages, _subpages) &&
            const DeepCollectionEquality()
                .equals(other._onlyAllowedUsers, _onlyAllowedUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tocTitle,
      pageTitle,
      filepath,
      const DeepCollectionEquality().hash(_subpages),
      const DeepCollectionEquality().hash(_onlyAllowedUsers));

  /// Create a copy of TableOfContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableOfContentImplCopyWith<_$TableOfContentImpl> get copyWith =>
      __$$TableOfContentImplCopyWithImpl<_$TableOfContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableOfContentImplToJson(
      this,
    );
  }
}

abstract class _TableOfContent extends TableOfContent {
  factory _TableOfContent(
      {required final String id,
      required final String tocTitle,
      required final String pageTitle,
      required final String filepath,
      required final List<TableOfContent> subpages,
      final List<String>? onlyAllowedUsers}) = _$TableOfContentImpl;
  _TableOfContent._() : super._();

  factory _TableOfContent.fromJson(Map<String, dynamic> json) =
      _$TableOfContentImpl.fromJson;

  @override
  String get id;
  @override
  String get tocTitle;
  @override
  String get pageTitle;
  @override
  String get filepath;
  @override
  List<TableOfContent> get subpages;
  @override
  List<String>? get onlyAllowedUsers;

  /// Create a copy of TableOfContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableOfContentImplCopyWith<_$TableOfContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
