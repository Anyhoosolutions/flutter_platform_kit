// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Arguments implements DiagnosticableTreeMixin {

// @Default(false) bool useTestDb,
 bool get useFakeData; bool get useDeviceEmulator; DateTime? get currentTime; String? get location; bool get enableDebugMode; bool get logoutAtStartup; bool get loginAtStartup; String? get userEmail; String? get userPassword; bool? get useFirebaseEmulator;
/// Create a copy of Arguments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArgumentsCopyWith<Arguments> get copyWith => _$ArgumentsCopyWithImpl<Arguments>(this as Arguments, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Arguments'))
    ..add(DiagnosticsProperty('useFakeData', useFakeData))..add(DiagnosticsProperty('useDeviceEmulator', useDeviceEmulator))..add(DiagnosticsProperty('currentTime', currentTime))..add(DiagnosticsProperty('location', location))..add(DiagnosticsProperty('enableDebugMode', enableDebugMode))..add(DiagnosticsProperty('logoutAtStartup', logoutAtStartup))..add(DiagnosticsProperty('loginAtStartup', loginAtStartup))..add(DiagnosticsProperty('userEmail', userEmail))..add(DiagnosticsProperty('userPassword', userPassword))..add(DiagnosticsProperty('useFirebaseEmulator', useFirebaseEmulator));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Arguments&&(identical(other.useFakeData, useFakeData) || other.useFakeData == useFakeData)&&(identical(other.useDeviceEmulator, useDeviceEmulator) || other.useDeviceEmulator == useDeviceEmulator)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.enableDebugMode, enableDebugMode) || other.enableDebugMode == enableDebugMode)&&(identical(other.logoutAtStartup, logoutAtStartup) || other.logoutAtStartup == logoutAtStartup)&&(identical(other.loginAtStartup, loginAtStartup) || other.loginAtStartup == loginAtStartup)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userPassword, userPassword) || other.userPassword == userPassword)&&(identical(other.useFirebaseEmulator, useFirebaseEmulator) || other.useFirebaseEmulator == useFirebaseEmulator));
}


@override
int get hashCode => Object.hash(runtimeType,useFakeData,useDeviceEmulator,currentTime,location,enableDebugMode,logoutAtStartup,loginAtStartup,userEmail,userPassword,useFirebaseEmulator);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Arguments(useFakeData: $useFakeData, useDeviceEmulator: $useDeviceEmulator, currentTime: $currentTime, location: $location, enableDebugMode: $enableDebugMode, logoutAtStartup: $logoutAtStartup, loginAtStartup: $loginAtStartup, userEmail: $userEmail, userPassword: $userPassword, useFirebaseEmulator: $useFirebaseEmulator)';
}


}

/// @nodoc
abstract mixin class $ArgumentsCopyWith<$Res>  {
  factory $ArgumentsCopyWith(Arguments value, $Res Function(Arguments) _then) = _$ArgumentsCopyWithImpl;
@useResult
$Res call({
 bool useFakeData, bool useDeviceEmulator, DateTime? currentTime, String? location, bool enableDebugMode, bool logoutAtStartup, bool loginAtStartup, String? userEmail, String? userPassword, bool? useFirebaseEmulator
});




}
/// @nodoc
class _$ArgumentsCopyWithImpl<$Res>
    implements $ArgumentsCopyWith<$Res> {
  _$ArgumentsCopyWithImpl(this._self, this._then);

  final Arguments _self;
  final $Res Function(Arguments) _then;

/// Create a copy of Arguments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? useFakeData = null,Object? useDeviceEmulator = null,Object? currentTime = freezed,Object? location = freezed,Object? enableDebugMode = null,Object? logoutAtStartup = null,Object? loginAtStartup = null,Object? userEmail = freezed,Object? userPassword = freezed,Object? useFirebaseEmulator = freezed,}) {
  return _then(_self.copyWith(
useFakeData: null == useFakeData ? _self.useFakeData : useFakeData // ignore: cast_nullable_to_non_nullable
as bool,useDeviceEmulator: null == useDeviceEmulator ? _self.useDeviceEmulator : useDeviceEmulator // ignore: cast_nullable_to_non_nullable
as bool,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,enableDebugMode: null == enableDebugMode ? _self.enableDebugMode : enableDebugMode // ignore: cast_nullable_to_non_nullable
as bool,logoutAtStartup: null == logoutAtStartup ? _self.logoutAtStartup : logoutAtStartup // ignore: cast_nullable_to_non_nullable
as bool,loginAtStartup: null == loginAtStartup ? _self.loginAtStartup : loginAtStartup // ignore: cast_nullable_to_non_nullable
as bool,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPassword: freezed == userPassword ? _self.userPassword : userPassword // ignore: cast_nullable_to_non_nullable
as String?,useFirebaseEmulator: freezed == useFirebaseEmulator ? _self.useFirebaseEmulator : useFirebaseEmulator // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Arguments].
extension ArgumentsPatterns on Arguments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Arguments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Arguments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Arguments value)  $default,){
final _that = this;
switch (_that) {
case _Arguments():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Arguments value)?  $default,){
final _that = this;
switch (_that) {
case _Arguments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool useFakeData,  bool useDeviceEmulator,  DateTime? currentTime,  String? location,  bool enableDebugMode,  bool logoutAtStartup,  bool loginAtStartup,  String? userEmail,  String? userPassword,  bool? useFirebaseEmulator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Arguments() when $default != null:
return $default(_that.useFakeData,_that.useDeviceEmulator,_that.currentTime,_that.location,_that.enableDebugMode,_that.logoutAtStartup,_that.loginAtStartup,_that.userEmail,_that.userPassword,_that.useFirebaseEmulator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool useFakeData,  bool useDeviceEmulator,  DateTime? currentTime,  String? location,  bool enableDebugMode,  bool logoutAtStartup,  bool loginAtStartup,  String? userEmail,  String? userPassword,  bool? useFirebaseEmulator)  $default,) {final _that = this;
switch (_that) {
case _Arguments():
return $default(_that.useFakeData,_that.useDeviceEmulator,_that.currentTime,_that.location,_that.enableDebugMode,_that.logoutAtStartup,_that.loginAtStartup,_that.userEmail,_that.userPassword,_that.useFirebaseEmulator);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool useFakeData,  bool useDeviceEmulator,  DateTime? currentTime,  String? location,  bool enableDebugMode,  bool logoutAtStartup,  bool loginAtStartup,  String? userEmail,  String? userPassword,  bool? useFirebaseEmulator)?  $default,) {final _that = this;
switch (_that) {
case _Arguments() when $default != null:
return $default(_that.useFakeData,_that.useDeviceEmulator,_that.currentTime,_that.location,_that.enableDebugMode,_that.logoutAtStartup,_that.loginAtStartup,_that.userEmail,_that.userPassword,_that.useFirebaseEmulator);case _:
  return null;

}
}

}

/// @nodoc


class _Arguments extends Arguments with DiagnosticableTreeMixin {
  const _Arguments({this.useFakeData = false, this.useDeviceEmulator = false, this.currentTime = null, this.location = null, this.enableDebugMode = false, this.logoutAtStartup = false, this.loginAtStartup = false, this.userEmail = null, this.userPassword = null, this.useFirebaseEmulator}): super._();
  

// @Default(false) bool useTestDb,
@override@JsonKey() final  bool useFakeData;
@override@JsonKey() final  bool useDeviceEmulator;
@override@JsonKey() final  DateTime? currentTime;
@override@JsonKey() final  String? location;
@override@JsonKey() final  bool enableDebugMode;
@override@JsonKey() final  bool logoutAtStartup;
@override@JsonKey() final  bool loginAtStartup;
@override@JsonKey() final  String? userEmail;
@override@JsonKey() final  String? userPassword;
@override final  bool? useFirebaseEmulator;

/// Create a copy of Arguments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArgumentsCopyWith<_Arguments> get copyWith => __$ArgumentsCopyWithImpl<_Arguments>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Arguments'))
    ..add(DiagnosticsProperty('useFakeData', useFakeData))..add(DiagnosticsProperty('useDeviceEmulator', useDeviceEmulator))..add(DiagnosticsProperty('currentTime', currentTime))..add(DiagnosticsProperty('location', location))..add(DiagnosticsProperty('enableDebugMode', enableDebugMode))..add(DiagnosticsProperty('logoutAtStartup', logoutAtStartup))..add(DiagnosticsProperty('loginAtStartup', loginAtStartup))..add(DiagnosticsProperty('userEmail', userEmail))..add(DiagnosticsProperty('userPassword', userPassword))..add(DiagnosticsProperty('useFirebaseEmulator', useFirebaseEmulator));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Arguments&&(identical(other.useFakeData, useFakeData) || other.useFakeData == useFakeData)&&(identical(other.useDeviceEmulator, useDeviceEmulator) || other.useDeviceEmulator == useDeviceEmulator)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.enableDebugMode, enableDebugMode) || other.enableDebugMode == enableDebugMode)&&(identical(other.logoutAtStartup, logoutAtStartup) || other.logoutAtStartup == logoutAtStartup)&&(identical(other.loginAtStartup, loginAtStartup) || other.loginAtStartup == loginAtStartup)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userPassword, userPassword) || other.userPassword == userPassword)&&(identical(other.useFirebaseEmulator, useFirebaseEmulator) || other.useFirebaseEmulator == useFirebaseEmulator));
}


@override
int get hashCode => Object.hash(runtimeType,useFakeData,useDeviceEmulator,currentTime,location,enableDebugMode,logoutAtStartup,loginAtStartup,userEmail,userPassword,useFirebaseEmulator);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Arguments(useFakeData: $useFakeData, useDeviceEmulator: $useDeviceEmulator, currentTime: $currentTime, location: $location, enableDebugMode: $enableDebugMode, logoutAtStartup: $logoutAtStartup, loginAtStartup: $loginAtStartup, userEmail: $userEmail, userPassword: $userPassword, useFirebaseEmulator: $useFirebaseEmulator)';
}


}

/// @nodoc
abstract mixin class _$ArgumentsCopyWith<$Res> implements $ArgumentsCopyWith<$Res> {
  factory _$ArgumentsCopyWith(_Arguments value, $Res Function(_Arguments) _then) = __$ArgumentsCopyWithImpl;
@override @useResult
$Res call({
 bool useFakeData, bool useDeviceEmulator, DateTime? currentTime, String? location, bool enableDebugMode, bool logoutAtStartup, bool loginAtStartup, String? userEmail, String? userPassword, bool? useFirebaseEmulator
});




}
/// @nodoc
class __$ArgumentsCopyWithImpl<$Res>
    implements _$ArgumentsCopyWith<$Res> {
  __$ArgumentsCopyWithImpl(this._self, this._then);

  final _Arguments _self;
  final $Res Function(_Arguments) _then;

/// Create a copy of Arguments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? useFakeData = null,Object? useDeviceEmulator = null,Object? currentTime = freezed,Object? location = freezed,Object? enableDebugMode = null,Object? logoutAtStartup = null,Object? loginAtStartup = null,Object? userEmail = freezed,Object? userPassword = freezed,Object? useFirebaseEmulator = freezed,}) {
  return _then(_Arguments(
useFakeData: null == useFakeData ? _self.useFakeData : useFakeData // ignore: cast_nullable_to_non_nullable
as bool,useDeviceEmulator: null == useDeviceEmulator ? _self.useDeviceEmulator : useDeviceEmulator // ignore: cast_nullable_to_non_nullable
as bool,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,enableDebugMode: null == enableDebugMode ? _self.enableDebugMode : enableDebugMode // ignore: cast_nullable_to_non_nullable
as bool,logoutAtStartup: null == logoutAtStartup ? _self.logoutAtStartup : logoutAtStartup // ignore: cast_nullable_to_non_nullable
as bool,loginAtStartup: null == loginAtStartup ? _self.loginAtStartup : loginAtStartup // ignore: cast_nullable_to_non_nullable
as bool,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPassword: freezed == userPassword ? _self.userPassword : userPassword // ignore: cast_nullable_to_non_nullable
as String?,useFirebaseEmulator: freezed == useFirebaseEmulator ? _self.useFirebaseEmulator : useFirebaseEmulator // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
