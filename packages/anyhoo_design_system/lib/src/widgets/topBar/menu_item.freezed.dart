// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnyhooTopBarMenuItem {

 Key get key; String get label; IconData? get icon; VoidCallback get onTap;
/// Create a copy of AnyhooTopBarMenuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooTopBarMenuItemCopyWith<AnyhooTopBarMenuItem> get copyWith => _$AnyhooTopBarMenuItemCopyWithImpl<AnyhooTopBarMenuItem>(this as AnyhooTopBarMenuItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooTopBarMenuItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,onTap);

@override
String toString() {
  return 'AnyhooTopBarMenuItem(key: $key, label: $label, icon: $icon, onTap: $onTap)';
}


}

/// @nodoc
abstract mixin class $AnyhooTopBarMenuItemCopyWith<$Res>  {
  factory $AnyhooTopBarMenuItemCopyWith(AnyhooTopBarMenuItem value, $Res Function(AnyhooTopBarMenuItem) _then) = _$AnyhooTopBarMenuItemCopyWithImpl;
@useResult
$Res call({
 Key key, String label, IconData? icon, VoidCallback onTap
});




}
/// @nodoc
class _$AnyhooTopBarMenuItemCopyWithImpl<$Res>
    implements $AnyhooTopBarMenuItemCopyWith<$Res> {
  _$AnyhooTopBarMenuItemCopyWithImpl(this._self, this._then);

  final AnyhooTopBarMenuItem _self;
  final $Res Function(AnyhooTopBarMenuItem) _then;

/// Create a copy of AnyhooTopBarMenuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? icon = freezed,Object? onTap = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooTopBarMenuItem].
extension AnyhooTopBarMenuItemPatterns on AnyhooTopBarMenuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooTopBarMenuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooTopBarMenuItem value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooTopBarMenuItem value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Key key,  String label,  IconData? icon,  VoidCallback onTap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.onTap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Key key,  String label,  IconData? icon,  VoidCallback onTap)  $default,) {final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem():
return $default(_that.key,_that.label,_that.icon,_that.onTap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Key key,  String label,  IconData? icon,  VoidCallback onTap)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooTopBarMenuItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.onTap);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooTopBarMenuItem implements AnyhooTopBarMenuItem {
  const _AnyhooTopBarMenuItem({required this.key, required this.label, required this.icon, required this.onTap});
  

@override final  Key key;
@override final  String label;
@override final  IconData? icon;
@override final  VoidCallback onTap;

/// Create a copy of AnyhooTopBarMenuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooTopBarMenuItemCopyWith<_AnyhooTopBarMenuItem> get copyWith => __$AnyhooTopBarMenuItemCopyWithImpl<_AnyhooTopBarMenuItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooTopBarMenuItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,onTap);

@override
String toString() {
  return 'AnyhooTopBarMenuItem(key: $key, label: $label, icon: $icon, onTap: $onTap)';
}


}

/// @nodoc
abstract mixin class _$AnyhooTopBarMenuItemCopyWith<$Res> implements $AnyhooTopBarMenuItemCopyWith<$Res> {
  factory _$AnyhooTopBarMenuItemCopyWith(_AnyhooTopBarMenuItem value, $Res Function(_AnyhooTopBarMenuItem) _then) = __$AnyhooTopBarMenuItemCopyWithImpl;
@override @useResult
$Res call({
 Key key, String label, IconData? icon, VoidCallback onTap
});




}
/// @nodoc
class __$AnyhooTopBarMenuItemCopyWithImpl<$Res>
    implements _$AnyhooTopBarMenuItemCopyWith<$Res> {
  __$AnyhooTopBarMenuItemCopyWithImpl(this._self, this._then);

  final _AnyhooTopBarMenuItem _self;
  final $Res Function(_AnyhooTopBarMenuItem) _then;

/// Create a copy of AnyhooTopBarMenuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? icon = freezed,Object? onTap = null,}) {
  return _then(_AnyhooTopBarMenuItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,
  ));
}


}

// dart format on
