import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final _log = Logger('GoRouterWrapper');

class GoRouterWrapper {
  void go(BuildContext context, String path) {
    _log.info('Going to $path');
    GoRouter.of(context).go(path);
  }

  Future<Object?> push(BuildContext context, String path, {Object? extra}) {
    _log.info('Pushing $path');
    if (extra != null) {
      return GoRouter.of(context).push(path, extra: extra);
    } else {
      return GoRouter.of(context).push(path);
    }
  }

  void pop(BuildContext context, Object? extra) {
    if (extra == null) {
      _log.info('Popping without extra');
      GoRouter.of(context).pop();
      return;
    }
    _log.info('Popping with extra: $extra');
    GoRouter.of(context).pop(extra);
  }
}
