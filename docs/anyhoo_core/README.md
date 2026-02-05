
# anyhoo_core

## Introduction

This package contains some model classes that are used across multiple other packages, as well as some helper classes or methods.

## Model classes

### Arguments

Holds the variable that the app was started with. See below for more information.

### AuthUser

An interface that will be used in `anyhoo_auth` for the type of user object returned when a user is logged in. Should be extended in the host app.

## Helper classes

### ArgumentsParser

This class will read environment variables or arguments passed in when starting an app on iOS or Android.
These can then be passed to other parts of the code, for example you might have a CurrentTimeRepository that will either use the 
defined one or just give the current time.

To pass in environment variables use `--dart-define`, e.g. `flutter run -d chrome --dart-define=CURRENT_TIME=2025-04-29T11:22:59.000Z`


To run the android app with arguments, use `adb shell am start -n com.example.example_app/com.example.example_app.MainActivity --es location America/Pittsburg --ez isFooEnabled true --ed fooValue 3.14 --ei fooInt 42`

To run the iOS app with arguments, use `xcrun simctl launch booted com.example.myapp -location America/Pittsburg -isFooEnabled "true" -fooValue 3.14 -fooInt 42`

### String extensions

Provides convenient extension methods on `String`:

- `capitalize()`: Capitalizes the first character of the string
- `stripRight(String suffix)`: Removes the specified suffix from the end of the string
- `repeat(int n)`: Repeats the string `n` times
- `substringSafe(int start, int end)`: Safely extracts a substring with automatic bounds checking

### AnyhooStringUtils

A utility class for string operations:

- `generateRandomString(int length, {...})`: Generates a random string of the specified length with configurable character sets (uppercase, lowercase, numbers, and special characters)


#### Supported arguments

##### bool useFakeData

Defines if mock services should be used. Can be helpful for working on the layout or whenever an internet connection isn't available.

For android/iOS: `useFakeData`  
--dart-define: `USE_FAKE_DATA`  

##### bool useDeviceEmulator

Can be used to specify if launch on an emulator or real device. This can then be used to know how to connect to services, such as Firebase emulator.

For android/iOS: `useFirebaseEmulator`  
--dart-define: `USE_FIREBASE_EMULATOR`  


##### DateTime? currentTime

Can be used to fake the current time of the app (should only be used for development and/or test)

Format: `2025-04-29T11:22:59.000Z`  

For android/iOS: `currentTime`  
--dart-define: `CURRENT_TIME`  

##### String? location

Can be used to fake the location of the app (should only be used for development and/or test)

Format: `America/New_York`

For android/iOS: `location`  
--dart-define: `LOCATION`  

##### bool logoutAtStartup

Can be used to automatically sign out when launching the app (should only be used for development and/or test)

For android/iOS: `logout`  
--dart-define: `LOGOUT`  

##### bool loginAtStartup

Can be used to automatically sign in when launching the app (should only be used for development and/or test)

For android/iOS: `login`  
--dart-define: `login`  

##### String? userEmail

Can be used to automatically sign in when launching the app (should only be used for development and/or test)

For android/iOS: `userEmail`  
--dart-define: `USER_EMAIL`  

##### String? userPassword

Can be used to automatically sign in when launching the app (should only be used for development and/or test)

For android/iOS: `userPassword`  
--dart-define: `USER_PASSWORD`  

##### bool useFirebaseAnalytics

Can be used to specify if analytics should be used or not. Typically it is not being used in debug mode (kDebugMode), 
but can be turned on for specific debugging purposes.

For android/iOS: `useFirebaseAnalytics`  
--dart-define: `USE_FIREBASE_ANALYTICS`  

