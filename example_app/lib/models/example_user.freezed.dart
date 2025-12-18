// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExampleUser {

 String get id; String get email; String get name; String? get photoUrl; int? get phoneNumber;
/// Create a copy of ExampleUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleUserCopyWith<ExampleUser> get copyWith => _$ExampleUserCopyWithImpl<ExampleUser>(this as ExampleUser, _$identity);

  /// Serializes this ExampleUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,photoUrl,phoneNumber);

@override
String toString() {
  return 'ExampleUser(id: $id, email: $email, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $ExampleUserCopyWith<$Res>  {
  factory $ExampleUserCopyWith(ExampleUser value, $Res Function(ExampleUser) _then) = _$ExampleUserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String name, String? photoUrl, int? phoneNumber
});




}
/// @nodoc
class _$ExampleUserCopyWithImpl<$Res>
    implements $ExampleUserCopyWith<$Res> {
  _$ExampleUserCopyWithImpl(this._self, this._then);

  final ExampleUser _self;
  final $Res Function(ExampleUser) _then;

/// Create a copy of ExampleUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = null,Object? photoUrl = freezed,Object? phoneNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleUser].
extension ExampleUserPatterns on ExampleUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleUser value)  $default,){
final _that = this;
switch (_that) {
case _ExampleUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleUser value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String name,  String? photoUrl,  int? phoneNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.photoUrl,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String name,  String? photoUrl,  int? phoneNumber)  $default,) {final _that = this;
switch (_that) {
case _ExampleUser():
return $default(_that.id,_that.email,_that.name,_that.photoUrl,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String name,  String? photoUrl,  int? phoneNumber)?  $default,) {final _that = this;
switch (_that) {
case _ExampleUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.photoUrl,_that.phoneNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExampleUser extends ExampleUser {
  const _ExampleUser({required this.id, required this.email, required this.name, this.photoUrl, this.phoneNumber}): super._();
  factory _ExampleUser.fromJson(Map<String, dynamic> json) => _$ExampleUserFromJson(json);

@override final  String id;
@override final  String email;
@override final  String name;
@override final  String? photoUrl;
@override final  int? phoneNumber;

/// Create a copy of ExampleUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleUserCopyWith<_ExampleUser> get copyWith => __$ExampleUserCopyWithImpl<_ExampleUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExampleUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,photoUrl,phoneNumber);

@override
String toString() {
  return 'ExampleUser(id: $id, email: $email, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$ExampleUserCopyWith<$Res> implements $ExampleUserCopyWith<$Res> {
  factory _$ExampleUserCopyWith(_ExampleUser value, $Res Function(_ExampleUser) _then) = __$ExampleUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String name, String? photoUrl, int? phoneNumber
});




}
/// @nodoc
class __$ExampleUserCopyWithImpl<$Res>
    implements _$ExampleUserCopyWith<$Res> {
  __$ExampleUserCopyWithImpl(this._self, this._then);

  final _ExampleUser _self;
  final $Res Function(_ExampleUser) _then;

/// Create a copy of ExampleUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = null,Object? photoUrl = freezed,Object? phoneNumber = freezed,}) {
  return _then(_ExampleUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
