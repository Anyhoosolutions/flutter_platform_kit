// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anyhoo_bottom_bar_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnyhooBottomBarItem {

 String get key; String get label; IconData get icon; String get route;
/// Create a copy of AnyhooBottomBarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooBottomBarItemCopyWith<AnyhooBottomBarItem> get copyWith => _$AnyhooBottomBarItemCopyWithImpl<AnyhooBottomBarItem>(this as AnyhooBottomBarItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooBottomBarItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.route, route) || other.route == route));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,route);

@override
String toString() {
  return 'AnyhooBottomBarItem(key: $key, label: $label, icon: $icon, route: $route)';
}


}

/// @nodoc
abstract mixin class $AnyhooBottomBarItemCopyWith<$Res>  {
  factory $AnyhooBottomBarItemCopyWith(AnyhooBottomBarItem value, $Res Function(AnyhooBottomBarItem) _then) = _$AnyhooBottomBarItemCopyWithImpl;
@useResult
$Res call({
 String key, String label, IconData icon, String route
});




}
/// @nodoc
class _$AnyhooBottomBarItemCopyWithImpl<$Res>
    implements $AnyhooBottomBarItemCopyWith<$Res> {
  _$AnyhooBottomBarItemCopyWithImpl(this._self, this._then);

  final AnyhooBottomBarItem _self;
  final $Res Function(AnyhooBottomBarItem) _then;

/// Create a copy of AnyhooBottomBarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? icon = null,Object? route = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooBottomBarItem].
extension AnyhooBottomBarItemPatterns on AnyhooBottomBarItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooBottomBarItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooBottomBarItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooBottomBarItem value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooBottomBarItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooBottomBarItem value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooBottomBarItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  IconData icon,  String route)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooBottomBarItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.route);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  IconData icon,  String route)  $default,) {final _that = this;
switch (_that) {
case _AnyhooBottomBarItem():
return $default(_that.key,_that.label,_that.icon,_that.route);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  IconData icon,  String route)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooBottomBarItem() when $default != null:
return $default(_that.key,_that.label,_that.icon,_that.route);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooBottomBarItem implements AnyhooBottomBarItem {
  const _AnyhooBottomBarItem({required this.key, required this.label, required this.icon, required this.route});
  

@override final  String key;
@override final  String label;
@override final  IconData icon;
@override final  String route;

/// Create a copy of AnyhooBottomBarItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooBottomBarItemCopyWith<_AnyhooBottomBarItem> get copyWith => __$AnyhooBottomBarItemCopyWithImpl<_AnyhooBottomBarItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooBottomBarItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.route, route) || other.route == route));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,icon,route);

@override
String toString() {
  return 'AnyhooBottomBarItem(key: $key, label: $label, icon: $icon, route: $route)';
}


}

/// @nodoc
abstract mixin class _$AnyhooBottomBarItemCopyWith<$Res> implements $AnyhooBottomBarItemCopyWith<$Res> {
  factory _$AnyhooBottomBarItemCopyWith(_AnyhooBottomBarItem value, $Res Function(_AnyhooBottomBarItem) _then) = __$AnyhooBottomBarItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, IconData icon, String route
});




}
/// @nodoc
class __$AnyhooBottomBarItemCopyWithImpl<$Res>
    implements _$AnyhooBottomBarItemCopyWith<$Res> {
  __$AnyhooBottomBarItemCopyWithImpl(this._self, this._then);

  final _AnyhooBottomBarItem _self;
  final $Res Function(_AnyhooBottomBarItem) _then;

/// Create a copy of AnyhooBottomBarItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? icon = null,Object? route = null,}) {
  return _then(_AnyhooBottomBarItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
