import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/waitingPageDemo/waiting_page_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WaitingPageDemoPageRoute extends AnyhooRoute<AnyhooRouteName> {
  WaitingPageDemoPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return WaitingPageDemoPage();
  };

  @override
  String get path => '/waiting';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.waiting;

  @override
  String get title => 'Waiting';
}
