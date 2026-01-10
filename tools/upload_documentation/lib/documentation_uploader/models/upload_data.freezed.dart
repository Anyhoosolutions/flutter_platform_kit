// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadData _$UploadDataFromJson(Map<String, dynamic> json) {
  return _UploadData.fromJson(json);
}

/// @nodoc
mixin _$UploadData {
  Metadata get metadata => throw _privateConstructorUsedError;
  List<Page> get pages => throw _privateConstructorUsedError;

  /// Serializes this UploadData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadDataCopyWith<UploadData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadDataCopyWith<$Res> {
  factory $UploadDataCopyWith(
          UploadData value, $Res Function(UploadData) then) =
      _$UploadDataCopyWithImpl<$Res, UploadData>;
  @useResult
  $Res call({Metadata metadata, List<Page> pages});

  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$UploadDataCopyWithImpl<$Res, $Val extends UploadData>
    implements $UploadDataCopyWith<$Res> {
  _$UploadDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? pages = null,
  }) {
    return _then(_value.copyWith(
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<Page>,
    ) as $Val);
  }

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UploadDataImplCopyWith<$Res>
    implements $UploadDataCopyWith<$Res> {
  factory _$$UploadDataImplCopyWith(
          _$UploadDataImpl value, $Res Function(_$UploadDataImpl) then) =
      __$$UploadDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Metadata metadata, List<Page> pages});

  @override
  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$UploadDataImplCopyWithImpl<$Res>
    extends _$UploadDataCopyWithImpl<$Res, _$UploadDataImpl>
    implements _$$UploadDataImplCopyWith<$Res> {
  __$$UploadDataImplCopyWithImpl(
      _$UploadDataImpl _value, $Res Function(_$UploadDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? pages = null,
  }) {
    return _then(_$UploadDataImpl(
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<Page>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadDataImpl implements _UploadData {
  _$UploadDataImpl({required this.metadata, required final List<Page> pages})
      : _pages = pages;

  factory _$UploadDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadDataImplFromJson(json);

  @override
  final Metadata metadata;
  final List<Page> _pages;
  @override
  List<Page> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  String toString() {
    return 'UploadData(metadata: $metadata, pages: $pages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadDataImpl &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, metadata, const DeepCollectionEquality().hash(_pages));

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadDataImplCopyWith<_$UploadDataImpl> get copyWith =>
      __$$UploadDataImplCopyWithImpl<_$UploadDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadDataImplToJson(
      this,
    );
  }
}

abstract class _UploadData implements UploadData {
  factory _UploadData(
      {required final Metadata metadata,
      required final List<Page> pages}) = _$UploadDataImpl;

  factory _UploadData.fromJson(Map<String, dynamic> json) =
      _$UploadDataImpl.fromJson;

  @override
  Metadata get metadata;
  @override
  List<Page> get pages;

  /// Create a copy of UploadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadDataImplCopyWith<_$UploadDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
