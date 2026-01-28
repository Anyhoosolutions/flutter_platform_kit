// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anyhoo_map_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnyhooMapSettings {

 double get initialZoom; bool get showUserLocation; bool get showUserLocationButton; bool get showZoomControls; bool get showMapToolbar; bool get showMyLocationButton;
/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooMapSettingsCopyWith<AnyhooMapSettings> get copyWith => _$AnyhooMapSettingsCopyWithImpl<AnyhooMapSettings>(this as AnyhooMapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooMapSettings&&(identical(other.initialZoom, initialZoom) || other.initialZoom == initialZoom)&&(identical(other.showUserLocation, showUserLocation) || other.showUserLocation == showUserLocation)&&(identical(other.showUserLocationButton, showUserLocationButton) || other.showUserLocationButton == showUserLocationButton)&&(identical(other.showZoomControls, showZoomControls) || other.showZoomControls == showZoomControls)&&(identical(other.showMapToolbar, showMapToolbar) || other.showMapToolbar == showMapToolbar)&&(identical(other.showMyLocationButton, showMyLocationButton) || other.showMyLocationButton == showMyLocationButton));
}


@override
int get hashCode => Object.hash(runtimeType,initialZoom,showUserLocation,showUserLocationButton,showZoomControls,showMapToolbar,showMyLocationButton);

@override
String toString() {
  return 'AnyhooMapSettings(initialZoom: $initialZoom, showUserLocation: $showUserLocation, showUserLocationButton: $showUserLocationButton, showZoomControls: $showZoomControls, showMapToolbar: $showMapToolbar, showMyLocationButton: $showMyLocationButton)';
}


}

/// @nodoc
abstract mixin class $AnyhooMapSettingsCopyWith<$Res>  {
  factory $AnyhooMapSettingsCopyWith(AnyhooMapSettings value, $Res Function(AnyhooMapSettings) _then) = _$AnyhooMapSettingsCopyWithImpl;
@useResult
$Res call({
 double initialZoom, bool showUserLocation, bool showUserLocationButton, bool showZoomControls, bool showMapToolbar, bool showMyLocationButton
});




}
/// @nodoc
class _$AnyhooMapSettingsCopyWithImpl<$Res>
    implements $AnyhooMapSettingsCopyWith<$Res> {
  _$AnyhooMapSettingsCopyWithImpl(this._self, this._then);

  final AnyhooMapSettings _self;
  final $Res Function(AnyhooMapSettings) _then;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialZoom = null,Object? showUserLocation = null,Object? showUserLocationButton = null,Object? showZoomControls = null,Object? showMapToolbar = null,Object? showMyLocationButton = null,}) {
  return _then(_self.copyWith(
initialZoom: null == initialZoom ? _self.initialZoom : initialZoom // ignore: cast_nullable_to_non_nullable
as double,showUserLocation: null == showUserLocation ? _self.showUserLocation : showUserLocation // ignore: cast_nullable_to_non_nullable
as bool,showUserLocationButton: null == showUserLocationButton ? _self.showUserLocationButton : showUserLocationButton // ignore: cast_nullable_to_non_nullable
as bool,showZoomControls: null == showZoomControls ? _self.showZoomControls : showZoomControls // ignore: cast_nullable_to_non_nullable
as bool,showMapToolbar: null == showMapToolbar ? _self.showMapToolbar : showMapToolbar // ignore: cast_nullable_to_non_nullable
as bool,showMyLocationButton: null == showMyLocationButton ? _self.showMyLocationButton : showMyLocationButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooMapSettings].
extension AnyhooMapSettingsPatterns on AnyhooMapSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooMapSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooMapSettings value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooMapSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooMapSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double initialZoom,  bool showUserLocation,  bool showUserLocationButton,  bool showZoomControls,  bool showMapToolbar,  bool showMyLocationButton)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
return $default(_that.initialZoom,_that.showUserLocation,_that.showUserLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.showMyLocationButton);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double initialZoom,  bool showUserLocation,  bool showUserLocationButton,  bool showZoomControls,  bool showMapToolbar,  bool showMyLocationButton)  $default,) {final _that = this;
switch (_that) {
case _AnyhooMapSettings():
return $default(_that.initialZoom,_that.showUserLocation,_that.showUserLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.showMyLocationButton);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double initialZoom,  bool showUserLocation,  bool showUserLocationButton,  bool showZoomControls,  bool showMapToolbar,  bool showMyLocationButton)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
return $default(_that.initialZoom,_that.showUserLocation,_that.showUserLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.showMyLocationButton);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooMapSettings implements AnyhooMapSettings {
  const _AnyhooMapSettings({this.initialZoom = 15, this.showUserLocation = true, this.showUserLocationButton = true, this.showZoomControls = true, this.showMapToolbar = true, this.showMyLocationButton = true});
  

@override@JsonKey() final  double initialZoom;
@override@JsonKey() final  bool showUserLocation;
@override@JsonKey() final  bool showUserLocationButton;
@override@JsonKey() final  bool showZoomControls;
@override@JsonKey() final  bool showMapToolbar;
@override@JsonKey() final  bool showMyLocationButton;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooMapSettingsCopyWith<_AnyhooMapSettings> get copyWith => __$AnyhooMapSettingsCopyWithImpl<_AnyhooMapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooMapSettings&&(identical(other.initialZoom, initialZoom) || other.initialZoom == initialZoom)&&(identical(other.showUserLocation, showUserLocation) || other.showUserLocation == showUserLocation)&&(identical(other.showUserLocationButton, showUserLocationButton) || other.showUserLocationButton == showUserLocationButton)&&(identical(other.showZoomControls, showZoomControls) || other.showZoomControls == showZoomControls)&&(identical(other.showMapToolbar, showMapToolbar) || other.showMapToolbar == showMapToolbar)&&(identical(other.showMyLocationButton, showMyLocationButton) || other.showMyLocationButton == showMyLocationButton));
}


@override
int get hashCode => Object.hash(runtimeType,initialZoom,showUserLocation,showUserLocationButton,showZoomControls,showMapToolbar,showMyLocationButton);

@override
String toString() {
  return 'AnyhooMapSettings(initialZoom: $initialZoom, showUserLocation: $showUserLocation, showUserLocationButton: $showUserLocationButton, showZoomControls: $showZoomControls, showMapToolbar: $showMapToolbar, showMyLocationButton: $showMyLocationButton)';
}


}

/// @nodoc
abstract mixin class _$AnyhooMapSettingsCopyWith<$Res> implements $AnyhooMapSettingsCopyWith<$Res> {
  factory _$AnyhooMapSettingsCopyWith(_AnyhooMapSettings value, $Res Function(_AnyhooMapSettings) _then) = __$AnyhooMapSettingsCopyWithImpl;
@override @useResult
$Res call({
 double initialZoom, bool showUserLocation, bool showUserLocationButton, bool showZoomControls, bool showMapToolbar, bool showMyLocationButton
});




}
/// @nodoc
class __$AnyhooMapSettingsCopyWithImpl<$Res>
    implements _$AnyhooMapSettingsCopyWith<$Res> {
  __$AnyhooMapSettingsCopyWithImpl(this._self, this._then);

  final _AnyhooMapSettings _self;
  final $Res Function(_AnyhooMapSettings) _then;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialZoom = null,Object? showUserLocation = null,Object? showUserLocationButton = null,Object? showZoomControls = null,Object? showMapToolbar = null,Object? showMyLocationButton = null,}) {
  return _then(_AnyhooMapSettings(
initialZoom: null == initialZoom ? _self.initialZoom : initialZoom // ignore: cast_nullable_to_non_nullable
as double,showUserLocation: null == showUserLocation ? _self.showUserLocation : showUserLocation // ignore: cast_nullable_to_non_nullable
as bool,showUserLocationButton: null == showUserLocationButton ? _self.showUserLocationButton : showUserLocationButton // ignore: cast_nullable_to_non_nullable
as bool,showZoomControls: null == showZoomControls ? _self.showZoomControls : showZoomControls // ignore: cast_nullable_to_non_nullable
as bool,showMapToolbar: null == showMapToolbar ? _self.showMapToolbar : showMapToolbar // ignore: cast_nullable_to_non_nullable
as bool,showMyLocationButton: null == showMyLocationButton ? _self.showMyLocationButton : showMyLocationButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
