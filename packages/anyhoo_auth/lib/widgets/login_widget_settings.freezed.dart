// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_widget_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginWidgetSettings {
  bool get showEmailSignIn;
  bool get showGoogleSignIn;
  bool get showAppleSignIn;
  bool get showAnonymousSignIn;

  /// Create a copy of LoginWidgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginWidgetSettingsCopyWith<LoginWidgetSettings> get copyWith =>
      _$LoginWidgetSettingsCopyWithImpl<LoginWidgetSettings>(
          this as LoginWidgetSettings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginWidgetSettings &&
            (identical(other.showEmailSignIn, showEmailSignIn) ||
                other.showEmailSignIn == showEmailSignIn) &&
            (identical(other.showGoogleSignIn, showGoogleSignIn) ||
                other.showGoogleSignIn == showGoogleSignIn) &&
            (identical(other.showAppleSignIn, showAppleSignIn) ||
                other.showAppleSignIn == showAppleSignIn) &&
            (identical(other.showAnonymousSignIn, showAnonymousSignIn) ||
                other.showAnonymousSignIn == showAnonymousSignIn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showEmailSignIn,
      showGoogleSignIn, showAppleSignIn, showAnonymousSignIn);

  @override
  String toString() {
    return 'LoginWidgetSettings(showEmailSignIn: $showEmailSignIn, showGoogleSignIn: $showGoogleSignIn, showAppleSignIn: $showAppleSignIn, showAnonymousSignIn: $showAnonymousSignIn)';
  }
}

/// @nodoc
abstract mixin class $LoginWidgetSettingsCopyWith<$Res> {
  factory $LoginWidgetSettingsCopyWith(
          LoginWidgetSettings value, $Res Function(LoginWidgetSettings) _then) =
      _$LoginWidgetSettingsCopyWithImpl;
  @useResult
  $Res call(
      {bool showEmailSignIn,
      bool showGoogleSignIn,
      bool showAppleSignIn,
      bool showAnonymousSignIn});
}

/// @nodoc
class _$LoginWidgetSettingsCopyWithImpl<$Res>
    implements $LoginWidgetSettingsCopyWith<$Res> {
  _$LoginWidgetSettingsCopyWithImpl(this._self, this._then);

  final LoginWidgetSettings _self;
  final $Res Function(LoginWidgetSettings) _then;

  /// Create a copy of LoginWidgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showEmailSignIn = null,
    Object? showGoogleSignIn = null,
    Object? showAppleSignIn = null,
    Object? showAnonymousSignIn = null,
  }) {
    return _then(_self.copyWith(
      showEmailSignIn: null == showEmailSignIn
          ? _self.showEmailSignIn
          : showEmailSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showGoogleSignIn: null == showGoogleSignIn
          ? _self.showGoogleSignIn
          : showGoogleSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showAppleSignIn: null == showAppleSignIn
          ? _self.showAppleSignIn
          : showAppleSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showAnonymousSignIn: null == showAnonymousSignIn
          ? _self.showAnonymousSignIn
          : showAnonymousSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LoginWidgetSettings].
extension LoginWidgetSettingsPatterns on LoginWidgetSettings {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginWidgetSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginWidgetSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginWidgetSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool showEmailSignIn, bool showGoogleSignIn,
            bool showAppleSignIn, bool showAnonymousSignIn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings() when $default != null:
        return $default(_that.showEmailSignIn, _that.showGoogleSignIn,
            _that.showAppleSignIn, _that.showAnonymousSignIn);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool showEmailSignIn, bool showGoogleSignIn,
            bool showAppleSignIn, bool showAnonymousSignIn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings():
        return $default(_that.showEmailSignIn, _that.showGoogleSignIn,
            _that.showAppleSignIn, _that.showAnonymousSignIn);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool showEmailSignIn, bool showGoogleSignIn,
            bool showAppleSignIn, bool showAnonymousSignIn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginWidgetSettings() when $default != null:
        return $default(_that.showEmailSignIn, _that.showGoogleSignIn,
            _that.showAppleSignIn, _that.showAnonymousSignIn);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LoginWidgetSettings implements LoginWidgetSettings {
  const _LoginWidgetSettings(
      {this.showEmailSignIn = true,
      this.showGoogleSignIn = true,
      this.showAppleSignIn = true,
      this.showAnonymousSignIn = true});

  @override
  @JsonKey()
  final bool showEmailSignIn;
  @override
  @JsonKey()
  final bool showGoogleSignIn;
  @override
  @JsonKey()
  final bool showAppleSignIn;
  @override
  @JsonKey()
  final bool showAnonymousSignIn;

  /// Create a copy of LoginWidgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginWidgetSettingsCopyWith<_LoginWidgetSettings> get copyWith =>
      __$LoginWidgetSettingsCopyWithImpl<_LoginWidgetSettings>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginWidgetSettings &&
            (identical(other.showEmailSignIn, showEmailSignIn) ||
                other.showEmailSignIn == showEmailSignIn) &&
            (identical(other.showGoogleSignIn, showGoogleSignIn) ||
                other.showGoogleSignIn == showGoogleSignIn) &&
            (identical(other.showAppleSignIn, showAppleSignIn) ||
                other.showAppleSignIn == showAppleSignIn) &&
            (identical(other.showAnonymousSignIn, showAnonymousSignIn) ||
                other.showAnonymousSignIn == showAnonymousSignIn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showEmailSignIn,
      showGoogleSignIn, showAppleSignIn, showAnonymousSignIn);

  @override
  String toString() {
    return 'LoginWidgetSettings(showEmailSignIn: $showEmailSignIn, showGoogleSignIn: $showGoogleSignIn, showAppleSignIn: $showAppleSignIn, showAnonymousSignIn: $showAnonymousSignIn)';
  }
}

/// @nodoc
abstract mixin class _$LoginWidgetSettingsCopyWith<$Res>
    implements $LoginWidgetSettingsCopyWith<$Res> {
  factory _$LoginWidgetSettingsCopyWith(_LoginWidgetSettings value,
          $Res Function(_LoginWidgetSettings) _then) =
      __$LoginWidgetSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool showEmailSignIn,
      bool showGoogleSignIn,
      bool showAppleSignIn,
      bool showAnonymousSignIn});
}

/// @nodoc
class __$LoginWidgetSettingsCopyWithImpl<$Res>
    implements _$LoginWidgetSettingsCopyWith<$Res> {
  __$LoginWidgetSettingsCopyWithImpl(this._self, this._then);

  final _LoginWidgetSettings _self;
  final $Res Function(_LoginWidgetSettings) _then;

  /// Create a copy of LoginWidgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? showEmailSignIn = null,
    Object? showGoogleSignIn = null,
    Object? showAppleSignIn = null,
    Object? showAnonymousSignIn = null,
  }) {
    return _then(_LoginWidgetSettings(
      showEmailSignIn: null == showEmailSignIn
          ? _self.showEmailSignIn
          : showEmailSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showGoogleSignIn: null == showGoogleSignIn
          ? _self.showGoogleSignIn
          : showGoogleSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showAppleSignIn: null == showAppleSignIn
          ? _self.showAppleSignIn
          : showAppleSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
      showAnonymousSignIn: null == showAnonymousSignIn
          ? _self.showAnonymousSignIn
          : showAnonymousSignIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
