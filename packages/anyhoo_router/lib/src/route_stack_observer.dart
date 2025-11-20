import 'package:flutter/material.dart';

class RouteStackObserver extends NavigatorObserver {
  final List<Route<dynamic>> routeStack = [];
  final List<String> routeStackNames = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    routeStackNames.add(DateTime.now().toIso8601String());
    // _log.info('Route pushed: ${route.settings.name}');
    // _log.info('Current stack depth: ${routeStack.length}');
    // _log.info('Current stack: ${routeStack.map((e) => e.settings.name)}');
    // _log.info('Current stack names: $routeStackNames');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.remove(route);
    routeStackNames.removeLast();
    // _log.info('Route popped: ${route.settings.name}');
    // _log.info('Current stack depth: ${routeStack.length}');
    // _log.info('Current stack: ${routeStack.map((e) => e.settings.name)}');
    // _log.info('Current stack names: $routeStackNames');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // _log.info('Route replaced: ${newRoute?.settings.name}');
    // _log.info('Current stack depth: ${routeStack.length}');
    // _log.info('Current stack: ${routeStack.map((e) => e.settings.name)}');
    // _log.info('Current stack names: $routeStackNames');
  }
}
