import 'package:anyhoo_models/anyhoo_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'anyhoo_auth_state.freezed.dart';

@freezed
abstract class AnyhooAuthState<T extends AnyhooUser> with _$AnyhooAuthState<T> {
  const factory AnyhooAuthState({
    T? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AnyhooAuthState<T>;

  const AnyhooAuthState._();

  bool get isAuthenticated => user != null;
}
