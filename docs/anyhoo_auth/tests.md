# Tests

Overview of test suites in this project.

## Flutter Unit/Widget Tests

### (root)
- `test/cubit/anyhoo_auth_cubit_test.dart`
  - AnyhooAuthCubit > initial state is correct when no user is logged in
  - AnyhooAuthCubit > initial state is correct when user is logged in
  - AnyhooAuthCubit > Auth State Changes > emits state with new user when auth state changes to signed in
  - AnyhooAuthCubit > Auth State Changes > emits state with null user when auth state changes to signed out
  - AnyhooAuthCubit > Auth State Changes > emits error state when auth state stream has error
  - AnyhooAuthCubit > Auth State Changes > calls multiple enhance user services in sequence
  - AnyhooAuthCubit > Login Methods > login emits loading then completes on success
  - AnyhooAuthCubit > Login Methods > login emits loading then error on failure
  - AnyhooAuthCubit > Login Methods > loginWithGoogle emits loading then completes on success
  - AnyhooAuthCubit > Login Methods > loginWithGoogle emits error on failure
  - AnyhooAuthCubit > Login Methods > loginWithApple emits loading then completes on success
  - AnyhooAuthCubit > Login Methods > loginWithApple emits error on failure
  - AnyhooAuthCubit > Login Methods > loginWithAnonymous emits loading then completes on success
  - AnyhooAuthCubit > Login Methods > loginWithAnonymous emits error on failure
  - AnyhooAuthCubit > Logout > logout emits loading then completes
  - AnyhooAuthCubit > Logout > logout emits error on failure
  - AnyhooAuthCubit > User Management > saveUser calls enhance services and updates state
  - AnyhooAuthCubit > User Management > saveUser calls multiple enhance services in sequence
  - AnyhooAuthCubit > User Management > saveUser emits error on failure
  - AnyhooAuthCubit > User Management > refreshUser calls enhance services and updates state
  - AnyhooAuthCubit > User Management > refreshUser calls multiple enhance services in sequence
  - AnyhooAuthCubit > User Management > refreshUser sets user to null initially then updates
  - AnyhooAuthCubit > Subscription Management > cancels subscription on close

## Patrol Integration Tests

*No tests found.*

## Firebase Functions Tests

*No tests found.*

## Firestore Rules Tests

*No tests found.*

