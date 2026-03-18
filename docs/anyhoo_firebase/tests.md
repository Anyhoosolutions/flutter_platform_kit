# Tests

Overview of test suites in this project.

## Flutter Unit/Widget Tests

### (root)
- `test/src/firestore_service_test.dart`
  - FirestoreService > getSnapshotsStream > returns stream of documents with id field
  - FirestoreService > getSnapshotsStream > applies orderBy when provided
  - FirestoreService > getSnapshotsStream > applies whereNullFields when provided
  - FirestoreService > getSnapshotsStream > applies limit when provided
  - FirestoreService > getDocumentIdsStreamAsJson > returns stream of JSON encoded documents
  - FirestoreService > getSnapshotsForDocument > returns stream of document data
  - FirestoreService > getSnapshotsForDocument > returns null when document does not exist
  - FirestoreService > getDocumentIdStreamAsJson > returns stream of JSON encoded document
  - FirestoreService > getSnapshotsList > returns list of documents with id field
  - FirestoreService > getSnapshotsList > applies query parameters correctly
  - FirestoreService > getSnapshotsListAsJson > returns JSON encoded list of documents
  - FirestoreService > getDocument > returns document data when document exists
  - FirestoreService > getDocument > returns null when document does not exist
  - FirestoreService > getDocument > rethrows exception on error
  - FirestoreService > getDocumentAsJson > returns JSON encoded document
  - FirestoreService > addDocument > creates document with provided docId
  - FirestoreService > addDocument > generates docId when not provided
  - FirestoreService > addDocument > adds idFields to data
  - FirestoreService > addDocumentAsJson > decodes JSON and calls addDocument
  - FirestoreService > updateDocument > updates document successfully
  - FirestoreService > updateDocument > throws exception on error
  - FirestoreService > updateDocumentAsJson > decodes JSON and calls updateDocument
  - FirestoreService > deleteDocument > deletes document successfully

## Patrol Integration Tests

*No tests found.*

## Firebase Functions Tests

*No tests found.*

## Firestore Rules Tests

*No tests found.*

