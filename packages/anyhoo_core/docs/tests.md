# Tests

Overview of test suites in this project.

## Flutter Unit/Widget Tests

### (root)
- `test/anyhoo_core_test.dart`
  - AuthUser > can be extended by concrete implementations
- `test/utils/string_utils_test.dart`
  - AnyhooStringUtils > generateRandomString > generates string of correct length
  - AnyhooStringUtils > generateRandomString > generates string with default parameters (uppercase, lowercase, numbers)
  - AnyhooStringUtils > generateRandomString > generates string with only uppercase letters
  - AnyhooStringUtils > generateRandomString > generates string with only lowercase letters
  - AnyhooStringUtils > generateRandomString > generates string with only numbers
  - AnyhooStringUtils > generateRandomString > generates string with special characters
  - AnyhooStringUtils > generateRandomString > generates string with only special characters
  - AnyhooStringUtils > generateRandomString > generates different strings on multiple calls
  - AnyhooStringUtils > generateRandomString > handles length of 0
  - AnyhooStringUtils > generateRandomString > handles length of 1
  - AnyhooStringUtils > generateRandomString > handles very long strings
  - AnyhooStringUtils > generateRandomString > throws error when all character sets are disabled

## Patrol Integration Tests

*No tests found.*

## Firebase Functions Tests

*No tests found.*

## Firestore Rules Tests

*No tests found.*

