
# anyhoo_remote_config

## Introduction

This package contains a `RemoteConfigService` interface as well as a `FirebaseRemoteConfigService` and 
a `FakeRemoteConfigService`.

`FirebaseAnyhooRemoteConfigService` sets in-app defaults, activates the last fetched template immediately, then fetches in the background. Realtime updates and a successful fetch are pushed through `getConfigUpdatesStream()`.

`RemoteConfigCubit` listens to that stream and emits a new `AnyhooRemoteConfigValues` instance from `withMap`. Pass `minimumFetchInterval: Duration.zero` in debug builds.

`FakeAnyhooRemoteConfigService` takes an initial string map and `update` pushes a later one.

