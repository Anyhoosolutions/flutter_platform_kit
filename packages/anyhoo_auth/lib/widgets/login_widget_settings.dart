import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_widget_settings.freezed.dart';

@freezed
abstract class LoginWidgetSettings with _$LoginWidgetSettings {
  const factory LoginWidgetSettings({
    @Default(true) bool showEmailSignIn,
    @Default(true) bool showGoogleSignIn,
    @Default(true) bool showAppleSignIn,
    @Default(true) bool showAnonymousSignIn,
  }) = _LoginWidgetSettings;
}
