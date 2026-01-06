// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anyhoo_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnyhooAuthState<T extends AnyhooUser> {
  T? get user;
  bool get isLoading;
  String? get errorMessage;

  /// Create a copy of AnyhooAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnyhooAuthStateCopyWith<T, AnyhooAuthState<T>> get copyWith =>
      _$AnyhooAuthStateCopyWithImpl<T, AnyhooAuthState<T>>(
          this as AnyhooAuthState<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnyhooAuthState<T> &&
            const DeepCollectionEquality().equals(other.user, user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(user), isLoading, errorMessage);

  @override
  String toString() {
    return 'AnyhooAuthState<$T>(user: $user, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $AnyhooAuthStateCopyWith<T extends AnyhooUser, $Res> {
  factory $AnyhooAuthStateCopyWith(
          AnyhooAuthState<T> value, $Res Function(AnyhooAuthState<T>) _then) =
      _$AnyhooAuthStateCopyWithImpl;
  @useResult
  $Res call({T? user, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$AnyhooAuthStateCopyWithImpl<T extends AnyhooUser, $Res>
    implements $AnyhooAuthStateCopyWith<T, $Res> {
  _$AnyhooAuthStateCopyWithImpl(this._self, this._then);

  final AnyhooAuthState<T> _self;
  final $Res Function(AnyhooAuthState<T>) _then;

  /// Create a copy of AnyhooAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as T?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AnyhooAuthState].
extension AnyhooAuthStatePatterns<T extends AnyhooUser> on AnyhooAuthState<T> {
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
    TResult Function(_AnyhooAuthState<T> value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState() when $default != null:
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
    TResult Function(_AnyhooAuthState<T> value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState():
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
    TResult? Function(_AnyhooAuthState<T> value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState() when $default != null:
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
    TResult Function(T? user, bool isLoading, String? errorMessage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState() when $default != null:
        return $default(_that.user, _that.isLoading, _that.errorMessage);
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
    TResult Function(T? user, bool isLoading, String? errorMessage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState():
        return $default(_that.user, _that.isLoading, _that.errorMessage);
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
    TResult? Function(T? user, bool isLoading, String? errorMessage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnyhooAuthState() when $default != null:
        return $default(_that.user, _that.isLoading, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AnyhooAuthState<T extends AnyhooUser> extends AnyhooAuthState<T> {
  const _AnyhooAuthState({this.user, this.isLoading = false, this.errorMessage})
      : super._();

  @override
  final T? user;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  /// Create a copy of AnyhooAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnyhooAuthStateCopyWith<T, _AnyhooAuthState<T>> get copyWith =>
      __$AnyhooAuthStateCopyWithImpl<T, _AnyhooAuthState<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnyhooAuthState<T> &&
            const DeepCollectionEquality().equals(other.user, user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(user), isLoading, errorMessage);

  @override
  String toString() {
    return 'AnyhooAuthState<$T>(user: $user, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$AnyhooAuthStateCopyWith<T extends AnyhooUser, $Res>
    implements $AnyhooAuthStateCopyWith<T, $Res> {
  factory _$AnyhooAuthStateCopyWith(
          _AnyhooAuthState<T> value, $Res Function(_AnyhooAuthState<T>) _then) =
      __$AnyhooAuthStateCopyWithImpl;
  @override
  @useResult
  $Res call({T? user, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$AnyhooAuthStateCopyWithImpl<T extends AnyhooUser, $Res>
    implements _$AnyhooAuthStateCopyWith<T, $Res> {
  __$AnyhooAuthStateCopyWithImpl(this._self, this._then);

  final _AnyhooAuthState<T> _self;
  final $Res Function(_AnyhooAuthState<T>) _then;

  /// Create a copy of AnyhooAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_AnyhooAuthState<T>(
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as T?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
