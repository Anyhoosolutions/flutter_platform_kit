// ignore_for_file: deprecated_member_use

import 'package:anyhoo_auth/widgets/login_widget_settings.dart';
import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_auth/widgets/login_widget.dart';

@widgetbook.UseCase(name: 'LoginWidget', type: LoginWidget, path: 'anyhoo_auth')
Widget build(BuildContext context) {
  final showLogo = context.knobs.boolean(label: 'Show logo', initialValue: true);
  final showEmailSignIn = context.knobs.boolean(label: 'Show email sign in', initialValue: true);
  final showGoogleSignIn = context.knobs.boolean(label: 'Show google sign in', initialValue: true);
  final showAppleSignIn = context.knobs.boolean(label: 'Show apple sign in', initialValue: true);
  final showAnonymousSignIn = context.knobs.boolean(label: 'Show anonymous sign in', initialValue: true);

  final loginWidgetSettings = LoginWidgetSettings(
    showEmailSignIn: showEmailSignIn,
    showGoogleSignIn: showGoogleSignIn,
    showAppleSignIn: showAppleSignIn,
    showAnonymousSignIn: showAnonymousSignIn,
  );

  final innerWidget = LoginWidget<AnyhooUser>(
    title: 'Example App',
    assetLogoPath: showLogo ? 'assets/images/baking.png' : null,
    loginWidgetSettings: loginWidgetSettings,
  );

  final widget = Scaffold(body: Center(child: innerWidget));

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
