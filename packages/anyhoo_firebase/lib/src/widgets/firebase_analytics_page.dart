import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class FirebaseAnalyticsPage extends StatelessWidget {
  const FirebaseAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.copyWith(bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SizedBox(height: 20), ..._getFirebaseAnalyticsButtons(context)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getFirebaseAnalyticsButtons(BuildContext context) {
    final spacing = 16.0;
    return [
      ElevatedButton(
        onPressed: () {
          FirebaseAnalytics.instance.logEvent(name: 'log_event');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sent custom log event')));
        },
        child: const Text("Analytics: Custom log event"),
      ),
      SizedBox(height: spacing),
      ElevatedButton(
        onPressed: () {
          FirebaseCrashlytics.instance.log('Custom log for crash');
          throw Exception();
        },
        child: const Text("Crashlytics: Throw Test Exception"),
      ),
      SizedBox(height: spacing),
      ElevatedButton(
        onPressed: () {
          FirebaseCrashlytics.instance.log('Custom log');
        },
        child: const Text("Crashlytics: Custom log"),
      ),
      SizedBox(height: spacing),

      ElevatedButton(
        onPressed: () {
          FirebaseCrashlytics.instance.setCustomKey('example', 'flutterfire');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Custom Key "example: flutterfire" has been set \n'
                'Key will appear in Firebase Console once an error has been reported.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        },
        child: const Text('Crashlytics: Key'),
      ),
      ElevatedButton(
        onPressed: () {
          FirebaseCrashlytics.instance.log('This is a log example');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'The message "This is a log example" has been logged \n'
                'Message will appear in Firebase Console once an error has been reported.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        },
        child: const Text('Crashlytics: Log'),
      ),
      ElevatedButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'App will crash is 5 seconds \n'
                'Please reopen to send data to Crashlytics',
              ),
              duration: Duration(seconds: 5),
            ),
          );

          // Delay crash for 5 seconds
          sleep(const Duration(seconds: 5));

          // Use FirebaseCrashlytics to throw an error. Use this for
          // confirmation that errors are being correctly reported.
          FirebaseCrashlytics.instance.crash();
        },
        child: const Text('Crashlytics: Crash'),
      ),
      ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thrown error has been caught and sent to Crashlytics.'),
              duration: Duration(seconds: 5),
            ),
          );

          // Example of thrown error, it will be caught and sent to
          // Crashlytics.
          throw StateError('Uncaught error thrown by app');
        },
        child: const Text('Crashlytics: Throw Error'),
      ),
      ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uncaught Exception that is handled by second parameter of runZonedGuarded.'),
              duration: Duration(seconds: 5),
            ),
          );

          // Example of an exception that does not get caught
          // by `FlutterError.onError` but is caught by
          // `runZonedGuarded`.
          runZonedGuarded(() {
            Future<void>.delayed(const Duration(seconds: 2), () {
              final list = <int>[];
              print(list[100]);
            });
          }, FirebaseCrashlytics.instance.recordError);
        },
        child: const Text('Crashlytics: Async out of bounds'),
      ),
      ElevatedButton(
        onPressed: () async {
          try {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Recorded Error'), duration: Duration(seconds: 5)));
            throw Error();
          } catch (e, s) {
            // "reason" will append the word "thrown" in the
            // Crashlytics console.
            await FirebaseCrashlytics.instance.recordError(e, s, reason: 'as an example of fatal error', fatal: true);
          }
        },
        child: const Text('Crashlytics: Record Fatal Error'),
      ),
      ElevatedButton(
        onPressed: () async {
          try {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Recorded Error'), duration: Duration(seconds: 5)));
            throw Error();
          } catch (e, s) {
            // "reason" will append the word "thrown" in the
            // Crashlytics console.
            await FirebaseCrashlytics.instance.recordError(e, s, reason: 'as an example of non-fatal error');
          }
        },
        child: const Text('Crashlytics: Record Non-Fatal Error'),
      ),
    ];
  }
}
