
# anyhoo_firebase

This package helps setting up Firebase, using an optional `Arguments` object to tell if it should use a Firebase emulator or not.
It will also initiate the `Firestore`, `Firebase auth`, and `Firebase storage` themselves.

## Usage

### AnyhooStorageService

This is basically a wrapper for FirebaseStorage (for now), but also exposes a fake implementation that can be used for testing (`AnyhooFakeStorageService`).
It also provides the ability to later support other storage platforms as needed.

