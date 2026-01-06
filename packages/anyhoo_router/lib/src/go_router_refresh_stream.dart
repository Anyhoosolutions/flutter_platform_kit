import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('GoRouterRefreshStream');

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      // Use the stream directly if it's already a broadcast stream,
      // otherwise convert it to broadcast to allow multiple listeners
      final broadcastStream = stream.isBroadcast ? stream : stream.asBroadcastStream();

      _subscriptions.add(
        broadcastStream.listen(
          (dynamic value) {
            _log.info('Stream event received, notifying GoRouter listeners');
            notifyListeners();
          },
          onError: (error) {
            _log.warning('Stream error in GoRouterRefreshStream', error);
            // Still notify listeners on error to allow redirect logic to handle it
            notifyListeners();
          },
        ),
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
