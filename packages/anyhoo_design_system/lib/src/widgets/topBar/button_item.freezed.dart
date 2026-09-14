// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'button_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnyhooTopBarButtonItem {

 Key get key; String get label; IconData? get icon; VoidCallback get onTap; Color? get color;
/// Create a copy of AnyhooTopBarButtonItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooTopBarButtonItemCopyWith<AnyhooTopBarButtonItem> get copyWith => _$AnyhooTopBarButtonItemCopyWithImpl<AnyhooTopBarButtonItem>(this as AnyhooTopBarButtonItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooTopBarButtonItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,onTap,color);

@override
String toString() {
  return 'AnyhooTopBarButtonItem(key: $key, label: $label, icon: $icon, onTap: $onTap, color: $color)';
}


}

/// @nodoc
abstract mixin class $AnyhooTopBarButtonItemCopyWith<$Res>  {
  factory $AnyhooTopBarButtonItemCopyWith(AnyhooTopBarButtonItem value, $Res Function(AnyhooTopBarButtonItem) _then) = _$AnyhooTopBarButtonItemCopyWithImpl;
@useResult
$Res call({
 Key key, String label, IconData? icon, VoidCallback onTap, Color? color
});




}
/// @nodoc
class _$AnyhooTopBarButtonItemCopyWithImpl<$Res>
    implements $AnyhooTopBarButtonItemCopyWith<$Res> {
  _$AnyhooTopBarButtonItemCopyWithImpl(this._self, this._then);

  final AnyhooTopBarButtonItem _self;
  final $Res Function(AnyhooTopBarButtonItem) _then;

/// Create a copy of AnyhooTopBarButtonItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? icon = freezed,Object? onTap = null,Object? color = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooTopBarButtonItem].
extension AnyhooTopBarButtonItemPatterns on AnyhooTopBarButtonItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooTopBarButtonItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooTopBarButtonItem value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooTopBarButtonItem value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Key key,  String label,  IconData? icon,  VoidCallback onTap,  Color? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.onTap,_that.color);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Key key,  String label,  IconData? icon,  VoidCallback onTap,  Color? color)  $default,) {final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem():
return $default(_that.key,_that.label,_that.icon,_that.onTap,_that.color);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Key key,  String label,  IconData? icon,  VoidCallback onTap,  Color? color)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooTopBarButtonItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.onTap,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooTopBarButtonItem implements AnyhooTopBarButtonItem {
  const _AnyhooTopBarButtonItem({required this.key, required this.label, required this.icon, required this.onTap, this.color = null});
  

@override final  Key key;
@override final  String label;
@override final  IconData? icon;
@override final  VoidCallback onTap;
@override@JsonKey() final  Color? color;

/// Create a copy of AnyhooTopBarButtonItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooTopBarButtonItemCopyWith<_AnyhooTopBarButtonItem> get copyWith => __$AnyhooTopBarButtonItemCopyWithImpl<_AnyhooTopBarButtonItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooTopBarButtonItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,onTap,color);

@override
String toString() {
  return 'AnyhooTopBarButtonItem(key: $key, label: $label, icon: $icon, onTap: $onTap, color: $color)';
}


}

/// @nodoc
abstract mixin class _$AnyhooTopBarButtonItemCopyWith<$Res> implements $AnyhooTopBarButtonItemCopyWith<$Res> {
  factory _$AnyhooTopBarButtonItemCopyWith(_AnyhooTopBarButtonItem value, $Res Function(_AnyhooTopBarButtonItem) _then) = __$AnyhooTopBarButtonItemCopyWithImpl;
@override @useResult
$Res call({
 Key key, String label, IconData? icon, VoidCallback onTap, Color? color
});




}
/// @nodoc
class __$AnyhooTopBarButtonItemCopyWithImpl<$Res>
    implements _$AnyhooTopBarButtonItemCopyWith<$Res> {
  __$AnyhooTopBarButtonItemCopyWithImpl(this._self, this._then);

  final _AnyhooTopBarButtonItem _self;
  final $Res Function(_AnyhooTopBarButtonItem) _then;

/// Create a copy of AnyhooTopBarButtonItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? icon = freezed,Object? onTap = null,Object? color = freezed,}) {
  return _then(_AnyhooTopBarButtonItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}


}

// dart format on
