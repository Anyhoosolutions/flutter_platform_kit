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

 double get initialZoom; AnyhooGoogleMapSettings? get google; AnyhooFlutterMapSettings? get flutter;
/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooMapSettingsCopyWith<AnyhooMapSettings> get copyWith => _$AnyhooMapSettingsCopyWithImpl<AnyhooMapSettings>(this as AnyhooMapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooMapSettings&&(identical(other.initialZoom, initialZoom) || other.initialZoom == initialZoom)&&(identical(other.google, google) || other.google == google)&&(identical(other.flutter, flutter) || other.flutter == flutter));
}


@override
int get hashCode => Object.hash(runtimeType,initialZoom,google,flutter);

@override
String toString() {
  return 'AnyhooMapSettings(initialZoom: $initialZoom, google: $google, flutter: $flutter)';
}


}

/// @nodoc
abstract mixin class $AnyhooMapSettingsCopyWith<$Res>  {
  factory $AnyhooMapSettingsCopyWith(AnyhooMapSettings value, $Res Function(AnyhooMapSettings) _then) = _$AnyhooMapSettingsCopyWithImpl;
@useResult
$Res call({
 double initialZoom, AnyhooGoogleMapSettings? google, AnyhooFlutterMapSettings? flutter
});


$AnyhooGoogleMapSettingsCopyWith<$Res>? get google;$AnyhooFlutterMapSettingsCopyWith<$Res>? get flutter;

}
/// @nodoc
class _$AnyhooMapSettingsCopyWithImpl<$Res>
    implements $AnyhooMapSettingsCopyWith<$Res> {
  _$AnyhooMapSettingsCopyWithImpl(this._self, this._then);

  final AnyhooMapSettings _self;
  final $Res Function(AnyhooMapSettings) _then;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialZoom = null,Object? google = freezed,Object? flutter = freezed,}) {
  return _then(_self.copyWith(
initialZoom: null == initialZoom ? _self.initialZoom : initialZoom // ignore: cast_nullable_to_non_nullable
as double,google: freezed == google ? _self.google : google // ignore: cast_nullable_to_non_nullable
as AnyhooGoogleMapSettings?,flutter: freezed == flutter ? _self.flutter : flutter // ignore: cast_nullable_to_non_nullable
as AnyhooFlutterMapSettings?,
  ));
}
/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnyhooGoogleMapSettingsCopyWith<$Res>? get google {
    if (_self.google == null) {
    return null;
  }

  return $AnyhooGoogleMapSettingsCopyWith<$Res>(_self.google!, (value) {
    return _then(_self.copyWith(google: value));
  });
}/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnyhooFlutterMapSettingsCopyWith<$Res>? get flutter {
    if (_self.flutter == null) {
    return null;
  }

  return $AnyhooFlutterMapSettingsCopyWith<$Res>(_self.flutter!, (value) {
    return _then(_self.copyWith(flutter: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double initialZoom,  AnyhooGoogleMapSettings? google,  AnyhooFlutterMapSettings? flutter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
return $default(_that.initialZoom,_that.google,_that.flutter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double initialZoom,  AnyhooGoogleMapSettings? google,  AnyhooFlutterMapSettings? flutter)  $default,) {final _that = this;
switch (_that) {
case _AnyhooMapSettings():
return $default(_that.initialZoom,_that.google,_that.flutter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double initialZoom,  AnyhooGoogleMapSettings? google,  AnyhooFlutterMapSettings? flutter)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooMapSettings() when $default != null:
return $default(_that.initialZoom,_that.google,_that.flutter);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooMapSettings extends AnyhooMapSettings {
  const _AnyhooMapSettings({this.initialZoom = 15, this.google, this.flutter}): super._();
  

@override@JsonKey() final  double initialZoom;
@override final  AnyhooGoogleMapSettings? google;
@override final  AnyhooFlutterMapSettings? flutter;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooMapSettingsCopyWith<_AnyhooMapSettings> get copyWith => __$AnyhooMapSettingsCopyWithImpl<_AnyhooMapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooMapSettings&&(identical(other.initialZoom, initialZoom) || other.initialZoom == initialZoom)&&(identical(other.google, google) || other.google == google)&&(identical(other.flutter, flutter) || other.flutter == flutter));
}


@override
int get hashCode => Object.hash(runtimeType,initialZoom,google,flutter);

@override
String toString() {
  return 'AnyhooMapSettings(initialZoom: $initialZoom, google: $google, flutter: $flutter)';
}


}

/// @nodoc
abstract mixin class _$AnyhooMapSettingsCopyWith<$Res> implements $AnyhooMapSettingsCopyWith<$Res> {
  factory _$AnyhooMapSettingsCopyWith(_AnyhooMapSettings value, $Res Function(_AnyhooMapSettings) _then) = __$AnyhooMapSettingsCopyWithImpl;
@override @useResult
$Res call({
 double initialZoom, AnyhooGoogleMapSettings? google, AnyhooFlutterMapSettings? flutter
});


@override $AnyhooGoogleMapSettingsCopyWith<$Res>? get google;@override $AnyhooFlutterMapSettingsCopyWith<$Res>? get flutter;

}
/// @nodoc
class __$AnyhooMapSettingsCopyWithImpl<$Res>
    implements _$AnyhooMapSettingsCopyWith<$Res> {
  __$AnyhooMapSettingsCopyWithImpl(this._self, this._then);

  final _AnyhooMapSettings _self;
  final $Res Function(_AnyhooMapSettings) _then;

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialZoom = null,Object? google = freezed,Object? flutter = freezed,}) {
  return _then(_AnyhooMapSettings(
initialZoom: null == initialZoom ? _self.initialZoom : initialZoom // ignore: cast_nullable_to_non_nullable
as double,google: freezed == google ? _self.google : google // ignore: cast_nullable_to_non_nullable
as AnyhooGoogleMapSettings?,flutter: freezed == flutter ? _self.flutter : flutter // ignore: cast_nullable_to_non_nullable
as AnyhooFlutterMapSettings?,
  ));
}

/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnyhooGoogleMapSettingsCopyWith<$Res>? get google {
    if (_self.google == null) {
    return null;
  }

  return $AnyhooGoogleMapSettingsCopyWith<$Res>(_self.google!, (value) {
    return _then(_self.copyWith(google: value));
  });
}/// Create a copy of AnyhooMapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnyhooFlutterMapSettingsCopyWith<$Res>? get flutter {
    if (_self.flutter == null) {
    return null;
  }

  return $AnyhooFlutterMapSettingsCopyWith<$Res>(_self.flutter!, (value) {
    return _then(_self.copyWith(flutter: value));
  });
}
}

/// @nodoc
mixin _$AnyhooGoogleMapSettings {

 bool get showUserLocation; bool get showMyLocationButton; bool get showZoomControls; bool get showMapToolbar;/// Cloud-based map style id. Off by default.
///
/// Setting this on mobile bills Google Dynamic Maps. Leave null unless you
/// have a Map ID and accept that cost.
 String? get mapId;
/// Create a copy of AnyhooGoogleMapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooGoogleMapSettingsCopyWith<AnyhooGoogleMapSettings> get copyWith => _$AnyhooGoogleMapSettingsCopyWithImpl<AnyhooGoogleMapSettings>(this as AnyhooGoogleMapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooGoogleMapSettings&&(identical(other.showUserLocation, showUserLocation) || other.showUserLocation == showUserLocation)&&(identical(other.showMyLocationButton, showMyLocationButton) || other.showMyLocationButton == showMyLocationButton)&&(identical(other.showZoomControls, showZoomControls) || other.showZoomControls == showZoomControls)&&(identical(other.showMapToolbar, showMapToolbar) || other.showMapToolbar == showMapToolbar)&&(identical(other.mapId, mapId) || other.mapId == mapId));
}


@override
int get hashCode => Object.hash(runtimeType,showUserLocation,showMyLocationButton,showZoomControls,showMapToolbar,mapId);

@override
String toString() {
  return 'AnyhooGoogleMapSettings(showUserLocation: $showUserLocation, showMyLocationButton: $showMyLocationButton, showZoomControls: $showZoomControls, showMapToolbar: $showMapToolbar, mapId: $mapId)';
}


}

/// @nodoc
abstract mixin class $AnyhooGoogleMapSettingsCopyWith<$Res>  {
  factory $AnyhooGoogleMapSettingsCopyWith(AnyhooGoogleMapSettings value, $Res Function(AnyhooGoogleMapSettings) _then) = _$AnyhooGoogleMapSettingsCopyWithImpl;
@useResult
$Res call({
 bool showUserLocation, bool showMyLocationButton, bool showZoomControls, bool showMapToolbar, String? mapId
});




}
/// @nodoc
class _$AnyhooGoogleMapSettingsCopyWithImpl<$Res>
    implements $AnyhooGoogleMapSettingsCopyWith<$Res> {
  _$AnyhooGoogleMapSettingsCopyWithImpl(this._self, this._then);

  final AnyhooGoogleMapSettings _self;
  final $Res Function(AnyhooGoogleMapSettings) _then;

/// Create a copy of AnyhooGoogleMapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showUserLocation = null,Object? showMyLocationButton = null,Object? showZoomControls = null,Object? showMapToolbar = null,Object? mapId = freezed,}) {
  return _then(_self.copyWith(
showUserLocation: null == showUserLocation ? _self.showUserLocation : showUserLocation // ignore: cast_nullable_to_non_nullable
as bool,showMyLocationButton: null == showMyLocationButton ? _self.showMyLocationButton : showMyLocationButton // ignore: cast_nullable_to_non_nullable
as bool,showZoomControls: null == showZoomControls ? _self.showZoomControls : showZoomControls // ignore: cast_nullable_to_non_nullable
as bool,showMapToolbar: null == showMapToolbar ? _self.showMapToolbar : showMapToolbar // ignore: cast_nullable_to_non_nullable
as bool,mapId: freezed == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooGoogleMapSettings].
extension AnyhooGoogleMapSettingsPatterns on AnyhooGoogleMapSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooGoogleMapSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooGoogleMapSettings value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooGoogleMapSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showUserLocation,  bool showMyLocationButton,  bool showZoomControls,  bool showMapToolbar,  String? mapId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings() when $default != null:
return $default(_that.showUserLocation,_that.showMyLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.mapId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showUserLocation,  bool showMyLocationButton,  bool showZoomControls,  bool showMapToolbar,  String? mapId)  $default,) {final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings():
return $default(_that.showUserLocation,_that.showMyLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.mapId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showUserLocation,  bool showMyLocationButton,  bool showZoomControls,  bool showMapToolbar,  String? mapId)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooGoogleMapSettings() when $default != null:
return $default(_that.showUserLocation,_that.showMyLocationButton,_that.showZoomControls,_that.showMapToolbar,_that.mapId);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooGoogleMapSettings implements AnyhooGoogleMapSettings {
  const _AnyhooGoogleMapSettings({this.showUserLocation = true, this.showMyLocationButton = true, this.showZoomControls = true, this.showMapToolbar = true, this.mapId});
  

@override@JsonKey() final  bool showUserLocation;
@override@JsonKey() final  bool showMyLocationButton;
@override@JsonKey() final  bool showZoomControls;
@override@JsonKey() final  bool showMapToolbar;
/// Cloud-based map style id. Off by default.
///
/// Setting this on mobile bills Google Dynamic Maps. Leave null unless you
/// have a Map ID and accept that cost.
@override final  String? mapId;

/// Create a copy of AnyhooGoogleMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooGoogleMapSettingsCopyWith<_AnyhooGoogleMapSettings> get copyWith => __$AnyhooGoogleMapSettingsCopyWithImpl<_AnyhooGoogleMapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooGoogleMapSettings&&(identical(other.showUserLocation, showUserLocation) || other.showUserLocation == showUserLocation)&&(identical(other.showMyLocationButton, showMyLocationButton) || other.showMyLocationButton == showMyLocationButton)&&(identical(other.showZoomControls, showZoomControls) || other.showZoomControls == showZoomControls)&&(identical(other.showMapToolbar, showMapToolbar) || other.showMapToolbar == showMapToolbar)&&(identical(other.mapId, mapId) || other.mapId == mapId));
}


@override
int get hashCode => Object.hash(runtimeType,showUserLocation,showMyLocationButton,showZoomControls,showMapToolbar,mapId);

@override
String toString() {
  return 'AnyhooGoogleMapSettings(showUserLocation: $showUserLocation, showMyLocationButton: $showMyLocationButton, showZoomControls: $showZoomControls, showMapToolbar: $showMapToolbar, mapId: $mapId)';
}


}

/// @nodoc
abstract mixin class _$AnyhooGoogleMapSettingsCopyWith<$Res> implements $AnyhooGoogleMapSettingsCopyWith<$Res> {
  factory _$AnyhooGoogleMapSettingsCopyWith(_AnyhooGoogleMapSettings value, $Res Function(_AnyhooGoogleMapSettings) _then) = __$AnyhooGoogleMapSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool showUserLocation, bool showMyLocationButton, bool showZoomControls, bool showMapToolbar, String? mapId
});




}
/// @nodoc
class __$AnyhooGoogleMapSettingsCopyWithImpl<$Res>
    implements _$AnyhooGoogleMapSettingsCopyWith<$Res> {
  __$AnyhooGoogleMapSettingsCopyWithImpl(this._self, this._then);

  final _AnyhooGoogleMapSettings _self;
  final $Res Function(_AnyhooGoogleMapSettings) _then;

/// Create a copy of AnyhooGoogleMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showUserLocation = null,Object? showMyLocationButton = null,Object? showZoomControls = null,Object? showMapToolbar = null,Object? mapId = freezed,}) {
  return _then(_AnyhooGoogleMapSettings(
showUserLocation: null == showUserLocation ? _self.showUserLocation : showUserLocation // ignore: cast_nullable_to_non_nullable
as bool,showMyLocationButton: null == showMyLocationButton ? _self.showMyLocationButton : showMyLocationButton // ignore: cast_nullable_to_non_nullable
as bool,showZoomControls: null == showZoomControls ? _self.showZoomControls : showZoomControls // ignore: cast_nullable_to_non_nullable
as bool,showMapToolbar: null == showMapToolbar ? _self.showMapToolbar : showMapToolbar // ignore: cast_nullable_to_non_nullable
as bool,mapId: freezed == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AnyhooFlutterMapSettings {

 String get urlTemplate; String get userAgentPackageName; String? get attribution; TileProvider? get tileProvider;
/// Create a copy of AnyhooFlutterMapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnyhooFlutterMapSettingsCopyWith<AnyhooFlutterMapSettings> get copyWith => _$AnyhooFlutterMapSettingsCopyWithImpl<AnyhooFlutterMapSettings>(this as AnyhooFlutterMapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnyhooFlutterMapSettings&&(identical(other.urlTemplate, urlTemplate) || other.urlTemplate == urlTemplate)&&(identical(other.userAgentPackageName, userAgentPackageName) || other.userAgentPackageName == userAgentPackageName)&&(identical(other.attribution, attribution) || other.attribution == attribution)&&(identical(other.tileProvider, tileProvider) || other.tileProvider == tileProvider));
}


@override
int get hashCode => Object.hash(runtimeType,urlTemplate,userAgentPackageName,attribution,tileProvider);

@override
String toString() {
  return 'AnyhooFlutterMapSettings(urlTemplate: $urlTemplate, userAgentPackageName: $userAgentPackageName, attribution: $attribution, tileProvider: $tileProvider)';
}


}

/// @nodoc
abstract mixin class $AnyhooFlutterMapSettingsCopyWith<$Res>  {
  factory $AnyhooFlutterMapSettingsCopyWith(AnyhooFlutterMapSettings value, $Res Function(AnyhooFlutterMapSettings) _then) = _$AnyhooFlutterMapSettingsCopyWithImpl;
@useResult
$Res call({
 String urlTemplate, String userAgentPackageName, String? attribution, TileProvider? tileProvider
});




}
/// @nodoc
class _$AnyhooFlutterMapSettingsCopyWithImpl<$Res>
    implements $AnyhooFlutterMapSettingsCopyWith<$Res> {
  _$AnyhooFlutterMapSettingsCopyWithImpl(this._self, this._then);

  final AnyhooFlutterMapSettings _self;
  final $Res Function(AnyhooFlutterMapSettings) _then;

/// Create a copy of AnyhooFlutterMapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? urlTemplate = null,Object? userAgentPackageName = null,Object? attribution = freezed,Object? tileProvider = freezed,}) {
  return _then(_self.copyWith(
urlTemplate: null == urlTemplate ? _self.urlTemplate : urlTemplate // ignore: cast_nullable_to_non_nullable
as String,userAgentPackageName: null == userAgentPackageName ? _self.userAgentPackageName : userAgentPackageName // ignore: cast_nullable_to_non_nullable
as String,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as String?,tileProvider: freezed == tileProvider ? _self.tileProvider : tileProvider // ignore: cast_nullable_to_non_nullable
as TileProvider?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnyhooFlutterMapSettings].
extension AnyhooFlutterMapSettingsPatterns on AnyhooFlutterMapSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnyhooFlutterMapSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnyhooFlutterMapSettings value)  $default,){
final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnyhooFlutterMapSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String urlTemplate,  String userAgentPackageName,  String? attribution,  TileProvider? tileProvider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings() when $default != null:
return $default(_that.urlTemplate,_that.userAgentPackageName,_that.attribution,_that.tileProvider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String urlTemplate,  String userAgentPackageName,  String? attribution,  TileProvider? tileProvider)  $default,) {final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings():
return $default(_that.urlTemplate,_that.userAgentPackageName,_that.attribution,_that.tileProvider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String urlTemplate,  String userAgentPackageName,  String? attribution,  TileProvider? tileProvider)?  $default,) {final _that = this;
switch (_that) {
case _AnyhooFlutterMapSettings() when $default != null:
return $default(_that.urlTemplate,_that.userAgentPackageName,_that.attribution,_that.tileProvider);case _:
  return null;

}
}

}

/// @nodoc


class _AnyhooFlutterMapSettings implements AnyhooFlutterMapSettings {
  const _AnyhooFlutterMapSettings({required this.urlTemplate, required this.userAgentPackageName, this.attribution, this.tileProvider});
  

@override final  String urlTemplate;
@override final  String userAgentPackageName;
@override final  String? attribution;
@override final  TileProvider? tileProvider;

/// Create a copy of AnyhooFlutterMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnyhooFlutterMapSettingsCopyWith<_AnyhooFlutterMapSettings> get copyWith => __$AnyhooFlutterMapSettingsCopyWithImpl<_AnyhooFlutterMapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnyhooFlutterMapSettings&&(identical(other.urlTemplate, urlTemplate) || other.urlTemplate == urlTemplate)&&(identical(other.userAgentPackageName, userAgentPackageName) || other.userAgentPackageName == userAgentPackageName)&&(identical(other.attribution, attribution) || other.attribution == attribution)&&(identical(other.tileProvider, tileProvider) || other.tileProvider == tileProvider));
}


@override
int get hashCode => Object.hash(runtimeType,urlTemplate,userAgentPackageName,attribution,tileProvider);

@override
String toString() {
  return 'AnyhooFlutterMapSettings(urlTemplate: $urlTemplate, userAgentPackageName: $userAgentPackageName, attribution: $attribution, tileProvider: $tileProvider)';
}


}

/// @nodoc
abstract mixin class _$AnyhooFlutterMapSettingsCopyWith<$Res> implements $AnyhooFlutterMapSettingsCopyWith<$Res> {
  factory _$AnyhooFlutterMapSettingsCopyWith(_AnyhooFlutterMapSettings value, $Res Function(_AnyhooFlutterMapSettings) _then) = __$AnyhooFlutterMapSettingsCopyWithImpl;
@override @useResult
$Res call({
 String urlTemplate, String userAgentPackageName, String? attribution, TileProvider? tileProvider
});




}
/// @nodoc
class __$AnyhooFlutterMapSettingsCopyWithImpl<$Res>
    implements _$AnyhooFlutterMapSettingsCopyWith<$Res> {
  __$AnyhooFlutterMapSettingsCopyWithImpl(this._self, this._then);

  final _AnyhooFlutterMapSettings _self;
  final $Res Function(_AnyhooFlutterMapSettings) _then;

/// Create a copy of AnyhooFlutterMapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? urlTemplate = null,Object? userAgentPackageName = null,Object? attribution = freezed,Object? tileProvider = freezed,}) {
  return _then(_AnyhooFlutterMapSettings(
urlTemplate: null == urlTemplate ? _self.urlTemplate : urlTemplate // ignore: cast_nullable_to_non_nullable
as String,userAgentPackageName: null == userAgentPackageName ? _self.userAgentPackageName : userAgentPackageName // ignore: cast_nullable_to_non_nullable
as String,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as String?,tileProvider: freezed == tileProvider ? _self.tileProvider : tileProvider // ignore: cast_nullable_to_non_nullable
as TileProvider?,
  ));
}


}

// dart format on
