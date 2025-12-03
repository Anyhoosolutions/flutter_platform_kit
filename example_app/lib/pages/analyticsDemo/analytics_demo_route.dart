import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyticsDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  AnalyticsDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Analytics Demo')),
        body: FirebaseAnalyticsPage(),
      );

  @override
  String get path => '/analytics';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.analytics;

  @override
  String get title => 'Analytics Demo';
}
