import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      _subscriptions.add(
        stream.asBroadcastStream().listen((dynamic value) {
          notifyListeners();
        }),
      );
    }
  }
  static String className = 'GoRouterRefreshStream';

  @override
  String toString() {
    return 'GoRouterRefreshStream';
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
