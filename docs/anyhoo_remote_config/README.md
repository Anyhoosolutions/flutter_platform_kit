
# anyhoo_remote_config

## Introduction

This package contains a `RemoteConfigService` interface as well as a `FirebaseRemoteConfigService` and 
a `FakeRemoteConfigService`.

The `FirebaseRemoteConfigService` listen to Firebase and fetches the values, then updates the passed in
`RemoteConfig` object and updates any listener to the `getConfigUpdatesStream()`.

