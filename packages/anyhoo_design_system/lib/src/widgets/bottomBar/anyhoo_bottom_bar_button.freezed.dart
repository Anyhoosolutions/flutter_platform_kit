// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anyhoo_bottom_bar_button.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnyhooBottomBarButton {

 String get label; IconData get icon; VoidCallback get onTap; Key? get key;
/// Create a copy of AnyhooBottomBarButton
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooBottomBarButtonCopyWith<AnyhooBottomBarButton> get copyWith => _$AnyhooBottomBarButtonCopyWithImpl<AnyhooBottomBarButton>(this as AnyhooBottomBarButton, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooBottomBarButton&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.key, key) || other.key == key));
}


@override
int get hashCode => Object.hash(runtimeType,label,icon,onTap,key);

@override
String toString() {
  return 'AnyhooBottomBarButton(label: $label, icon: $icon, onTap: $onTap, key: $key)';
}


}

/// @nodoc
abstract mixin class $AnyhooBottomBarButtonCopyWith<$Res>  {
  factory $AnyhooBottomBarButtonCopyWith(AnyhooBottomBarButton value, $Res Function(AnyhooBottomBarButton) _then) = _$AnyhooBottomBarButtonCopyWithImpl;
@useResult
$Res call({
 String label, IconData icon, VoidCallback onTap, Key? key
});




}
/// @nodoc
class _$AnyhooBottomBarButtonCopyWithImpl<$Res>
    implements $AnyhooBottomBarButtonCopyWith<$Res> {
  _$AnyhooBottomBarButtonCopyWithImpl(this._self, this._then);

  final AnyhooBottomBarButton _self;
  final $Res Function(AnyhooBottomBarButton) _then;

/// Create a copy of AnyhooBottomBarButton
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? icon = null,Object? onTap = null,Object? key = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooBottomBarButton].
extension AnyhooBottomBarButtonPatterns on AnyhooBottomBarButton {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooBottomBarButton value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooBottomBarButton() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooBottomBarButton value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooBottomBarButton():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooBottomBarButton value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooBottomBarButton() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  IconData icon,  VoidCallback onTap,  Key? key)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooBottomBarButton() when $default != null:
return $default(_that.label,_that.icon,_that.onTap,_that.key);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  IconData icon,  VoidCallback onTap,  Key? key)  $default,) {final _that = this;
switch (_that) {
case _AnyhooBottomBarButton():
return $default(_that.label,_that.icon,_that.onTap,_that.key);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  IconData icon,  VoidCallback onTap,  Key? key)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooBottomBarButton() when $default != null:
return $default(_that.label,_that.icon,_that.onTap,_that.key);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooBottomBarButton implements AnyhooBottomBarButton {
  const _AnyhooBottomBarButton({required this.label, required this.icon, required this.onTap, this.key = null});
  

@override final  String label;
@override final  IconData icon;
@override final  VoidCallback onTap;
@override@JsonKey() final  Key? key;

/// Create a copy of AnyhooBottomBarButton
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooBottomBarButtonCopyWith<_AnyhooBottomBarButton> get copyWith => __$AnyhooBottomBarButtonCopyWithImpl<_AnyhooBottomBarButton>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooBottomBarButton&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.key, key) || other.key == key));
}


@override
int get hashCode => Object.hash(runtimeType,label,icon,onTap,key);

@override
String toString() {
  return 'AnyhooBottomBarButton(label: $label, icon: $icon, onTap: $onTap, key: $key)';
}


}

/// @nodoc
abstract mixin class _$AnyhooBottomBarButtonCopyWith<$Res> implements $AnyhooBottomBarButtonCopyWith<$Res> {
  factory _$AnyhooBottomBarButtonCopyWith(_AnyhooBottomBarButton value, $Res Function(_AnyhooBottomBarButton) _then) = __$AnyhooBottomBarButtonCopyWithImpl;
@override @useResult
$Res call({
 String label, IconData icon, VoidCallback onTap, Key? key
});




}
/// @nodoc
class __$AnyhooBottomBarButtonCopyWithImpl<$Res>
    implements _$AnyhooBottomBarButtonCopyWith<$Res> {
  __$AnyhooBottomBarButtonCopyWithImpl(this._self, this._then);

  final _AnyhooBottomBarButton _self;
  final $Res Function(_AnyhooBottomBarButton) _then;

/// Create a copy of AnyhooBottomBarButton
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? icon = null,Object? onTap = null,Object? key = freezed,}) {
  return _then(_AnyhooBottomBarButton(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as VoidCallback,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key?,
  ));
}


}

// dart format on
