// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_button_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionButtonInfo {

 IconData get icon; Null Function() get onTap;
/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionButtonInfoCopyWith<ActionButtonInfo> get copyWith => _$ActionButtonInfoCopyWithImpl<ActionButtonInfo>(this as ActionButtonInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionButtonInfo&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap));
}


@override
int get hashCode => Object.hash(runtimeType,icon,onTap);

@override
String toString() {
  return 'ActionButtonInfo(icon: $icon, onTap: $onTap)';
}


}

/// @nodoc
abstract mixin class $ActionButtonInfoCopyWith<$Res>  {
  factory $ActionButtonInfoCopyWith(ActionButtonInfo value, $Res Function(ActionButtonInfo) _then) = _$ActionButtonInfoCopyWithImpl;
@useResult
$Res call({
 IconData icon, Null Function() onTap
});




}
/// @nodoc
class _$ActionButtonInfoCopyWithImpl<$Res>
    implements $ActionButtonInfoCopyWith<$Res> {
  _$ActionButtonInfoCopyWithImpl(this._self, this._then);

  final ActionButtonInfo _self;
  final $Res Function(ActionButtonInfo) _then;

/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? onTap = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as Null Function(),
  ));
}

}


/// Adds pattern-matching-related methods to [ActionButtonInfo].
extension ActionButtonInfoPatterns on ActionButtonInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NormalActionButtonInfo value)?  normal,TResult Function( OverflowActionButtonInfo value)?  overflow,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NormalActionButtonInfo() when normal != null:
return normal(_that);case OverflowActionButtonInfo() when overflow != null:
return overflow(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NormalActionButtonInfo value)  normal,required TResult Function( OverflowActionButtonInfo value)  overflow,}){
final _that = this;
switch (_that) {
case NormalActionButtonInfo():
return normal(_that);case OverflowActionButtonInfo():
return overflow(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NormalActionButtonInfo value)?  normal,TResult? Function( OverflowActionButtonInfo value)?  overflow,}){
final _that = this;
switch (_that) {
case NormalActionButtonInfo() when normal != null:
return normal(_that);case OverflowActionButtonInfo() when overflow != null:
return overflow(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( IconData icon,  Null Function() onTap,  String name)?  normal,TResult Function( IconData icon,  Null Function() onTap,  String title)?  overflow,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NormalActionButtonInfo() when normal != null:
return normal(_that.icon,_that.onTap,_that.name);case OverflowActionButtonInfo() when overflow != null:
return overflow(_that.icon,_that.onTap,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( IconData icon,  Null Function() onTap,  String name)  normal,required TResult Function( IconData icon,  Null Function() onTap,  String title)  overflow,}) {final _that = this;
switch (_that) {
case NormalActionButtonInfo():
return normal(_that.icon,_that.onTap,_that.name);case OverflowActionButtonInfo():
return overflow(_that.icon,_that.onTap,_that.title);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( IconData icon,  Null Function() onTap,  String name)?  normal,TResult? Function( IconData icon,  Null Function() onTap,  String title)?  overflow,}) {final _that = this;
switch (_that) {
case NormalActionButtonInfo() when normal != null:
return normal(_that.icon,_that.onTap,_that.name);case OverflowActionButtonInfo() when overflow != null:
return overflow(_that.icon,_that.onTap,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class NormalActionButtonInfo implements ActionButtonInfo {
  const NormalActionButtonInfo({required this.icon, required this.onTap, required this.name});
  

@override final  IconData icon;
@override final  Null Function() onTap;
 final  String name;

/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NormalActionButtonInfoCopyWith<NormalActionButtonInfo> get copyWith => _$NormalActionButtonInfoCopyWithImpl<NormalActionButtonInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NormalActionButtonInfo&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,icon,onTap,name);

@override
String toString() {
  return 'ActionButtonInfo.normal(icon: $icon, onTap: $onTap, name: $name)';
}


}

/// @nodoc
abstract mixin class $NormalActionButtonInfoCopyWith<$Res> implements $ActionButtonInfoCopyWith<$Res> {
  factory $NormalActionButtonInfoCopyWith(NormalActionButtonInfo value, $Res Function(NormalActionButtonInfo) _then) = _$NormalActionButtonInfoCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, Null Function() onTap, String name
});




}
/// @nodoc
class _$NormalActionButtonInfoCopyWithImpl<$Res>
    implements $NormalActionButtonInfoCopyWith<$Res> {
  _$NormalActionButtonInfoCopyWithImpl(this._self, this._then);

  final NormalActionButtonInfo _self;
  final $Res Function(NormalActionButtonInfo) _then;

/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? onTap = null,Object? name = null,}) {
  return _then(NormalActionButtonInfo(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as Null Function(),name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OverflowActionButtonInfo implements ActionButtonInfo {
  const OverflowActionButtonInfo({required this.icon, required this.onTap, required this.title});
  

@override final  IconData icon;
@override final  Null Function() onTap;
 final  String title;

/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverflowActionButtonInfoCopyWith<OverflowActionButtonInfo> get copyWith => _$OverflowActionButtonInfoCopyWithImpl<OverflowActionButtonInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverflowActionButtonInfo&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,icon,onTap,title);

@override
String toString() {
  return 'ActionButtonInfo.overflow(icon: $icon, onTap: $onTap, title: $title)';
}


}

/// @nodoc
abstract mixin class $OverflowActionButtonInfoCopyWith<$Res> implements $ActionButtonInfoCopyWith<$Res> {
  factory $OverflowActionButtonInfoCopyWith(OverflowActionButtonInfo value, $Res Function(OverflowActionButtonInfo) _then) = _$OverflowActionButtonInfoCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, Null Function() onTap, String title
});




}
/// @nodoc
class _$OverflowActionButtonInfoCopyWithImpl<$Res>
    implements $OverflowActionButtonInfoCopyWith<$Res> {
  _$OverflowActionButtonInfoCopyWithImpl(this._self, this._then);

  final OverflowActionButtonInfo _self;
  final $Res Function(OverflowActionButtonInfo) _then;

/// Create a copy of ActionButtonInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? onTap = null,Object? title = null,}) {
  return _then(OverflowActionButtonInfo(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as Null Function(),title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
