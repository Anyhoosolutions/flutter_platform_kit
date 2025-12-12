// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emulator_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmulatorConfig {

 String get host; String? get hostIp; bool get useDeviceEmulator; bool? get overrideUseFirebaseEmulator; bool get useFirebaseAuth; bool get useFirebaseFirestore; bool get useFirebaseStorage; int get authPort; int get firestorePort; int get storagePort;
/// Create a copy of EmulatorConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmulatorConfigCopyWith<EmulatorConfig> get copyWith => _$EmulatorConfigCopyWithImpl<EmulatorConfig>(this as EmulatorConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmulatorConfig&&(identical(other.host, host) || other.host == host)&&(identical(other.hostIp, hostIp) || other.hostIp == hostIp)&&(identical(other.useDeviceEmulator, useDeviceEmulator) || other.useDeviceEmulator == useDeviceEmulator)&&(identical(other.overrideUseFirebaseEmulator, overrideUseFirebaseEmulator) || other.overrideUseFirebaseEmulator == overrideUseFirebaseEmulator)&&(identical(other.useFirebaseAuth, useFirebaseAuth) || other.useFirebaseAuth == useFirebaseAuth)&&(identical(other.useFirebaseFirestore, useFirebaseFirestore) || other.useFirebaseFirestore == useFirebaseFirestore)&&(identical(other.useFirebaseStorage, useFirebaseStorage) || other.useFirebaseStorage == useFirebaseStorage)&&(identical(other.authPort, authPort) || other.authPort == authPort)&&(identical(other.firestorePort, firestorePort) || other.firestorePort == firestorePort)&&(identical(other.storagePort, storagePort) || other.storagePort == storagePort));
}


@override
int get hashCode => Object.hash(runtimeType,host,hostIp,useDeviceEmulator,overrideUseFirebaseEmulator,useFirebaseAuth,useFirebaseFirestore,useFirebaseStorage,authPort,firestorePort,storagePort);

@override
String toString() {
  return 'EmulatorConfig(host: $host, hostIp: $hostIp, useDeviceEmulator: $useDeviceEmulator, overrideUseFirebaseEmulator: $overrideUseFirebaseEmulator, useFirebaseAuth: $useFirebaseAuth, useFirebaseFirestore: $useFirebaseFirestore, useFirebaseStorage: $useFirebaseStorage, authPort: $authPort, firestorePort: $firestorePort, storagePort: $storagePort)';
}


}

/// @nodoc
abstract mixin class $EmulatorConfigCopyWith<$Res>  {
  factory $EmulatorConfigCopyWith(EmulatorConfig value, $Res Function(EmulatorConfig) _then) = _$EmulatorConfigCopyWithImpl;
@useResult
$Res call({
 String host, String? hostIp, bool useDeviceEmulator, bool? overrideUseFirebaseEmulator, bool useFirebaseAuth, bool useFirebaseFirestore, bool useFirebaseStorage, int authPort, int firestorePort, int storagePort
});




}
/// @nodoc
class _$EmulatorConfigCopyWithImpl<$Res>
    implements $EmulatorConfigCopyWith<$Res> {
  _$EmulatorConfigCopyWithImpl(this._self, this._then);

  final EmulatorConfig _self;
  final $Res Function(EmulatorConfig) _then;

/// Create a copy of EmulatorConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? hostIp = freezed,Object? useDeviceEmulator = null,Object? overrideUseFirebaseEmulator = freezed,Object? useFirebaseAuth = null,Object? useFirebaseFirestore = null,Object? useFirebaseStorage = null,Object? authPort = null,Object? firestorePort = null,Object? storagePort = null,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,hostIp: freezed == hostIp ? _self.hostIp : hostIp // ignore: cast_nullable_to_non_nullable
as String?,useDeviceEmulator: null == useDeviceEmulator ? _self.useDeviceEmulator : useDeviceEmulator // ignore: cast_nullable_to_non_nullable
as bool,overrideUseFirebaseEmulator: freezed == overrideUseFirebaseEmulator ? _self.overrideUseFirebaseEmulator : overrideUseFirebaseEmulator // ignore: cast_nullable_to_non_nullable
as bool?,useFirebaseAuth: null == useFirebaseAuth ? _self.useFirebaseAuth : useFirebaseAuth // ignore: cast_nullable_to_non_nullable
as bool,useFirebaseFirestore: null == useFirebaseFirestore ? _self.useFirebaseFirestore : useFirebaseFirestore // ignore: cast_nullable_to_non_nullable
as bool,useFirebaseStorage: null == useFirebaseStorage ? _self.useFirebaseStorage : useFirebaseStorage // ignore: cast_nullable_to_non_nullable
as bool,authPort: null == authPort ? _self.authPort : authPort // ignore: cast_nullable_to_non_nullable
as int,firestorePort: null == firestorePort ? _self.firestorePort : firestorePort // ignore: cast_nullable_to_non_nullable
as int,storagePort: null == storagePort ? _self.storagePort : storagePort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmulatorConfig].
extension EmulatorConfigPatterns on EmulatorConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmulatorConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmulatorConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmulatorConfig value)  $default,){
final _that = this;
switch (_that) {
case _EmulatorConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmulatorConfig value)?  $default,){
final _that = this;
switch (_that) {
case _EmulatorConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  String? hostIp,  bool useDeviceEmulator,  bool? overrideUseFirebaseEmulator,  bool useFirebaseAuth,  bool useFirebaseFirestore,  bool useFirebaseStorage,  int authPort,  int firestorePort,  int storagePort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmulatorConfig() when $default != null:
return $default(_that.host,_that.hostIp,_that.useDeviceEmulator,_that.overrideUseFirebaseEmulator,_that.useFirebaseAuth,_that.useFirebaseFirestore,_that.useFirebaseStorage,_that.authPort,_that.firestorePort,_that.storagePort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  String? hostIp,  bool useDeviceEmulator,  bool? overrideUseFirebaseEmulator,  bool useFirebaseAuth,  bool useFirebaseFirestore,  bool useFirebaseStorage,  int authPort,  int firestorePort,  int storagePort)  $default,) {final _that = this;
switch (_that) {
case _EmulatorConfig():
return $default(_that.host,_that.hostIp,_that.useDeviceEmulator,_that.overrideUseFirebaseEmulator,_that.useFirebaseAuth,_that.useFirebaseFirestore,_that.useFirebaseStorage,_that.authPort,_that.firestorePort,_that.storagePort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  String? hostIp,  bool useDeviceEmulator,  bool? overrideUseFirebaseEmulator,  bool useFirebaseAuth,  bool useFirebaseFirestore,  bool useFirebaseStorage,  int authPort,  int firestorePort,  int storagePort)?  $default,) {final _that = this;
switch (_that) {
case _EmulatorConfig() when $default != null:
return $default(_that.host,_that.hostIp,_that.useDeviceEmulator,_that.overrideUseFirebaseEmulator,_that.useFirebaseAuth,_that.useFirebaseFirestore,_that.useFirebaseStorage,_that.authPort,_that.firestorePort,_that.storagePort);case _:
  return null;

}
}

}

/// @nodoc


class _EmulatorConfig implements EmulatorConfig {
   _EmulatorConfig({this.host = 'localhost', this.hostIp = null, this.useDeviceEmulator = true, this.overrideUseFirebaseEmulator = null, this.useFirebaseAuth = true, this.useFirebaseFirestore = true, this.useFirebaseStorage = true, this.authPort = 9099, this.firestorePort = 8080, this.storagePort = 9199});
  

@override@JsonKey() final  String host;
@override@JsonKey() final  String? hostIp;
@override@JsonKey() final  bool useDeviceEmulator;
@override@JsonKey() final  bool? overrideUseFirebaseEmulator;
@override@JsonKey() final  bool useFirebaseAuth;
@override@JsonKey() final  bool useFirebaseFirestore;
@override@JsonKey() final  bool useFirebaseStorage;
@override@JsonKey() final  int authPort;
@override@JsonKey() final  int firestorePort;
@override@JsonKey() final  int storagePort;

/// Create a copy of EmulatorConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmulatorConfigCopyWith<_EmulatorConfig> get copyWith => __$EmulatorConfigCopyWithImpl<_EmulatorConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmulatorConfig&&(identical(other.host, host) || other.host == host)&&(identical(other.hostIp, hostIp) || other.hostIp == hostIp)&&(identical(other.useDeviceEmulator, useDeviceEmulator) || other.useDeviceEmulator == useDeviceEmulator)&&(identical(other.overrideUseFirebaseEmulator, overrideUseFirebaseEmulator) || other.overrideUseFirebaseEmulator == overrideUseFirebaseEmulator)&&(identical(other.useFirebaseAuth, useFirebaseAuth) || other.useFirebaseAuth == useFirebaseAuth)&&(identical(other.useFirebaseFirestore, useFirebaseFirestore) || other.useFirebaseFirestore == useFirebaseFirestore)&&(identical(other.useFirebaseStorage, useFirebaseStorage) || other.useFirebaseStorage == useFirebaseStorage)&&(identical(other.authPort, authPort) || other.authPort == authPort)&&(identical(other.firestorePort, firestorePort) || other.firestorePort == firestorePort)&&(identical(other.storagePort, storagePort) || other.storagePort == storagePort));
}


@override
int get hashCode => Object.hash(runtimeType,host,hostIp,useDeviceEmulator,overrideUseFirebaseEmulator,useFirebaseAuth,useFirebaseFirestore,useFirebaseStorage,authPort,firestorePort,storagePort);

@override
String toString() {
  return 'EmulatorConfig(host: $host, hostIp: $hostIp, useDeviceEmulator: $useDeviceEmulator, overrideUseFirebaseEmulator: $overrideUseFirebaseEmulator, useFirebaseAuth: $useFirebaseAuth, useFirebaseFirestore: $useFirebaseFirestore, useFirebaseStorage: $useFirebaseStorage, authPort: $authPort, firestorePort: $firestorePort, storagePort: $storagePort)';
}


}

/// @nodoc
abstract mixin class _$EmulatorConfigCopyWith<$Res> implements $EmulatorConfigCopyWith<$Res> {
  factory _$EmulatorConfigCopyWith(_EmulatorConfig value, $Res Function(_EmulatorConfig) _then) = __$EmulatorConfigCopyWithImpl;
@override @useResult
$Res call({
 String host, String? hostIp, bool useDeviceEmulator, bool? overrideUseFirebaseEmulator, bool useFirebaseAuth, bool useFirebaseFirestore, bool useFirebaseStorage, int authPort, int firestorePort, int storagePort
});




}
/// @nodoc
class __$EmulatorConfigCopyWithImpl<$Res>
    implements _$EmulatorConfigCopyWith<$Res> {
  __$EmulatorConfigCopyWithImpl(this._self, this._then);

  final _EmulatorConfig _self;
  final $Res Function(_EmulatorConfig) _then;

/// Create a copy of EmulatorConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? hostIp = freezed,Object? useDeviceEmulator = null,Object? overrideUseFirebaseEmulator = freezed,Object? useFirebaseAuth = null,Object? useFirebaseFirestore = null,Object? useFirebaseStorage = null,Object? authPort = null,Object? firestorePort = null,Object? storagePort = null,}) {
  return _then(_EmulatorConfig(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,hostIp: freezed == hostIp ? _self.hostIp : hostIp // ignore: cast_nullable_to_non_nullable
as String?,useDeviceEmulator: null == useDeviceEmulator ? _self.useDeviceEmulator : useDeviceEmulator // ignore: cast_nullable_to_non_nullable
as bool,overrideUseFirebaseEmulator: freezed == overrideUseFirebaseEmulator ? _self.overrideUseFirebaseEmulator : overrideUseFirebaseEmulator // ignore: cast_nullable_to_non_nullable
as bool?,useFirebaseAuth: null == useFirebaseAuth ? _self.useFirebaseAuth : useFirebaseAuth // ignore: cast_nullable_to_non_nullable
as bool,useFirebaseFirestore: null == useFirebaseFirestore ? _self.useFirebaseFirestore : useFirebaseFirestore // ignore: cast_nullable_to_non_nullable
as bool,useFirebaseStorage: null == useFirebaseStorage ? _self.useFirebaseStorage : useFirebaseStorage // ignore: cast_nullable_to_non_nullable
as bool,authPort: null == authPort ? _self.authPort : authPort // ignore: cast_nullable_to_non_nullable
as int,firestorePort: null == firestorePort ? _self.firestorePort : firestorePort // ignore: cast_nullable_to_non_nullable
as int,storagePort: null == storagePort ? _self.storagePort : storagePort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
