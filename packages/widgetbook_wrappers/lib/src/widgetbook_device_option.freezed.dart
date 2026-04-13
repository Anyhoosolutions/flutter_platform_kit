// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widgetbook_device_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WidgetbookDeviceOption {

 DeviceInfo get device; String get label;
/// Create a copy of WidgetbookDeviceOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetbookDeviceOptionCopyWith<WidgetbookDeviceOption> get copyWith => _$WidgetbookDeviceOptionCopyWithImpl<WidgetbookDeviceOption>(this as WidgetbookDeviceOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetbookDeviceOption&&(identical(other.device, device) || other.device == device)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,device,label);

@override
String toString() {
  return 'WidgetbookDeviceOption(device: $device, label: $label)';
}


}

/// @nodoc
abstract mixin class $WidgetbookDeviceOptionCopyWith<$Res>  {
  factory $WidgetbookDeviceOptionCopyWith(WidgetbookDeviceOption value, $Res Function(WidgetbookDeviceOption) _then) = _$WidgetbookDeviceOptionCopyWithImpl;
@useResult
$Res call({
 DeviceInfo device, String label
});




}
/// @nodoc
class _$WidgetbookDeviceOptionCopyWithImpl<$Res>
    implements $WidgetbookDeviceOptionCopyWith<$Res> {
  _$WidgetbookDeviceOptionCopyWithImpl(this._self, this._then);

  final WidgetbookDeviceOption _self;
  final $Res Function(WidgetbookDeviceOption) _then;

/// Create a copy of WidgetbookDeviceOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? label = null,}) {
  return _then(_self.copyWith(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetbookDeviceOption].
extension WidgetbookDeviceOptionPatterns on WidgetbookDeviceOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _WidgetbookDeviceOption value)?  raw,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetbookDeviceOption() when raw != null:
return raw(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _WidgetbookDeviceOption value)  raw,}){
final _that = this;
switch (_that) {
case _WidgetbookDeviceOption():
return raw(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _WidgetbookDeviceOption value)?  raw,}){
final _that = this;
switch (_that) {
case _WidgetbookDeviceOption() when raw != null:
return raw(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DeviceInfo device,  String label)?  raw,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetbookDeviceOption() when raw != null:
return raw(_that.device,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DeviceInfo device,  String label)  raw,}) {final _that = this;
switch (_that) {
case _WidgetbookDeviceOption():
return raw(_that.device,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DeviceInfo device,  String label)?  raw,}) {final _that = this;
switch (_that) {
case _WidgetbookDeviceOption() when raw != null:
return raw(_that.device,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _WidgetbookDeviceOption extends WidgetbookDeviceOption {
  const _WidgetbookDeviceOption({required this.device, required this.label}): super._();
  

@override final  DeviceInfo device;
@override final  String label;

/// Create a copy of WidgetbookDeviceOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetbookDeviceOptionCopyWith<_WidgetbookDeviceOption> get copyWith => __$WidgetbookDeviceOptionCopyWithImpl<_WidgetbookDeviceOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetbookDeviceOption&&(identical(other.device, device) || other.device == device)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,device,label);

@override
String toString() {
  return 'WidgetbookDeviceOption.raw(device: $device, label: $label)';
}


}

/// @nodoc
abstract mixin class _$WidgetbookDeviceOptionCopyWith<$Res> implements $WidgetbookDeviceOptionCopyWith<$Res> {
  factory _$WidgetbookDeviceOptionCopyWith(_WidgetbookDeviceOption value, $Res Function(_WidgetbookDeviceOption) _then) = __$WidgetbookDeviceOptionCopyWithImpl;
@override @useResult
$Res call({
 DeviceInfo device, String label
});




}
/// @nodoc
class __$WidgetbookDeviceOptionCopyWithImpl<$Res>
    implements _$WidgetbookDeviceOptionCopyWith<$Res> {
  __$WidgetbookDeviceOptionCopyWithImpl(this._self, this._then);

  final _WidgetbookDeviceOption _self;
  final $Res Function(_WidgetbookDeviceOption) _then;

/// Create a copy of WidgetbookDeviceOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? label = null,}) {
  return _then(_WidgetbookDeviceOption(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
