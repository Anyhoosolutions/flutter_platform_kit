import 'package:anyhoo_router/src/anyhoo_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class AnyhooRouteSorter<T extends Enum> {
  AnyhooRouteSorter(this.routeList);

  final _log = Logger('AnyhooRouteSorter');
  final List<AnyhooRoute> routeList;

  List<RouteBase> getRoutes() {
    // Build nested route structure
    final rootPage = routeList.firstWhere((page) => page.path == '/');
    final nestedRoutes = _buildNestedRoutes(routeList);

    final rootRoute = GoRoute(
      path: rootPage.path,
      name: rootPage.title,
      builder: _getBuilder(rootPage),
      routes: nestedRoutes,
    );

    return [rootRoute];
  }

  List<GoRoute> _buildNestedRoutes(List<AnyhooRoute> routes) {
    // Group pages by their path hierarchy while preserving order
    final routeMap = <String, _RouteNode>{};
    final routeOrder = <String>[];

    // Skip root page
    final nonRootPages = routes.where((page) => page.path != '/').toList();

    // Build the route tree
    for (final page in nonRootPages) {
      final segments = page.path.split('/').where((s) => s.isNotEmpty).toList();
      _addToRouteTree(routeMap, segments, page, routeOrder);
    }

    // Convert the tree to GoRoutes with preserved order
    return _convertToGoRoutesWithOrder(routeMap, routeOrder);
  }

  void _addToRouteTree(
    Map<String, _RouteNode> routeMap,
    List<String> segments,
    AnyhooRoute route,
    List<String> routeOrder,
  ) {
    if (segments.isEmpty) return;

    final firstSegment = segments.first;
    final remainingSegments = segments.skip(1).toList();

    // Get or create the route node
    final routeNode = routeMap.putIfAbsent(firstSegment, () {
      if (!routeOrder.contains(firstSegment)) {
        routeOrder.add(firstSegment);
      }
      return _RouteNode(firstSegment);
    });

    if (remainingSegments.isEmpty) {
      // This is the final segment, assign the page
      routeNode.route = route;
    } else {
      // Continue building the tree recursively
      _addToRouteTree(routeNode.children, remainingSegments, route, routeNode.childOrder);
    }
  }

  List<GoRoute> _convertToGoRoutesWithOrder(Map<String, _RouteNode> routeMap, List<String> routeOrder) {
    return routeOrder.map((segment) {
      final node = routeMap[segment]!;
      final childRoutes = _convertToGoRoutesWithOrder(node.children, node.childOrder);

      if (node.route == null) {
        _log.severe('Missing page ${node.segment}');
      }
      if (node.route?.routeName.name == null) {
        _log.severe('Missing route name ${node.segment}, ${node.route}');
        // throw Exception('Missing route name ${node.segment}');
      }
      final goRoute = GoRoute(
        path: node.segment,
        name: node.route?.routeName.name ?? 'missing_route_name',
        builder: _getBuilder(node.route),
        routes: childRoutes,
      );
      return goRoute;
    }).toList();
  }

  GoRouterWidgetBuilder _getBuilder(AnyhooRoute? page) {
    if (page == null) {
      _log.severe('Missing page');
      return (context, state) => Text('Missing page');
    }
    if (page.redirect != null) {
      return (context, state) => Text('Should redirect');
    }
    if (page.builder == null) {
      _log.severe('Missing builder ${page.routeName}');
      return (context, state) => Text('Missing builder');
    }
    final builder = page.builder!;
    return (context, state) => builder(context, state) ?? Text('Builder is returning null');
  }
}

class _RouteNode {
  final String segment;
  AnyhooRoute? route;
  final Map<String, _RouteNode> children = {};
  final List<String> childOrder = [];

  _RouteNode(this.segment);
}
