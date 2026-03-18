# Tests

Overview of test suites in this project.

## Flutter Unit/Widget Tests

### (root)
- `test/src/anyhoo_route_redirector_test.dart`
  - AnyhooRouteRedirector.getAllPaths > should return root path for single root route
  - AnyhooRouteRedirector.getAllPaths > should return paths for flat routes
  - AnyhooRouteRedirector.getAllPaths > should handle routes without leading slash
  - AnyhooRouteRedirector.getAllPaths > should handle routes with trailing slash
  - AnyhooRouteRedirector.getAllPaths > should handle nested routes with root parent
  - AnyhooRouteRedirector.getAllPaths > should handle nested routes with non-root parent
  - AnyhooRouteRedirector.getAllPaths > should handle deeply nested routes
  - AnyhooRouteRedirector.getAllPaths > should handle parameterized routes
  - AnyhooRouteRedirector.getAllPaths > should handle mixed nested and flat routes
  - AnyhooRouteRedirector.getAllPaths > should handle multiple nested routes at same level
  - AnyhooRouteRedirector.getAllPaths > should normalize paths to lowercase
  - AnyhooRouteRedirector.getAllPaths > should handle empty routes list
  - AnyhooRouteRedirector.getAllPaths > should handle routes with complex nested structure
  - AnyhooRouteRedirector.getAllPaths > should handle routes with parent path ending in slash
  - AnyhooRouteRedirector.getAllPaths > should handle child routes without leading slash
- `test/src/anyhoo_router_test.dart`
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if route doesn't exist
  - AnyhooRouter > Redirect if route doesn't exist > should redirect to specified route if route doesn't exist
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for valid parameterized route with single param
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for valid parameterized route with alphanumeric param
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for valid parameterized route with UUID param
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for valid parameterized route with multiple params
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if parameterized route has wrong number of segments
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if parameterized route has too few segments
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if multi-param route has wrong number of segments
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if multi-param route has too many segments
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if path has wrong segment name before param
  - AnyhooRouter > Redirect if route doesn't exist > should redirect if path has wrong segment name in middle of multi-param route
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for root path
  - AnyhooRouter > Redirect if route doesn't exist > should NOT redirect for exact match routes
  - AnyhooRouter > Redirect if route doesn't exist > should redirect for completely non-existent path
  - AnyhooRouter > Redirect if route doesn't exist > should handle case-insensitive matching
  - AnyhooRouter > Redirect if route doesn't exist > should handle case-insensitive matching for parameterized routes
  - AnyhooRouter > should go to route if no redirect is needed
  - AnyhooRouter > should redirect: /profiles -> /users
  - AnyhooRouter > should redirect recursively: /accounts -> /profiles -> /users
  - AnyhooRouter > should redirect recursively with path parameters
  - AnyhooRouter > should redirect to login when not authenticated and route requires login
  - AnyhooRouter > should NOT redirect to login when authenticated and route requires login
  - AnyhooRouter > should redirect to home when authenticated and on login page
  - AnyhooRouter > should NOT redirect to home when NOT authenticated and on login page

## Patrol Integration Tests

*No tests found.*

## Firebase Functions Tests

*No tests found.*

## Firestore Rules Tests

*No tests found.*

