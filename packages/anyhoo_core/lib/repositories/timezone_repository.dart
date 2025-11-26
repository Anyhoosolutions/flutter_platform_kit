import 'package:anyhoo_core/models/arguments.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneRepository {
  final Arguments arguments;

  const TimeZoneRepository({required this.arguments});

  /// Initialize timezone data (should be called once, typically in main)
  void initializeTimeZones() {
    tz.initializeTimeZones();
  }

  /// Get the user's current timezone name
  /// If Arguments.location is set, it will be used as the timezone
  /// Otherwise, it returns the device's local timezone
  String getUserTimeZone() {
    initializeTimeZones();

    // Check if location is provided via arguments
    if (arguments.location != null && arguments.location!.isNotEmpty) {
      try {
        // Validate that the location is a valid timezone
        final location = tz.getLocation(arguments.location!);
        return location.name;
      } catch (e) {
        // If the provided location is not a valid timezone, fall back to local
        return tz.local.name;
      }
    }

    // Return the device's local timezone
    return tz.local.name;
  }

  /// Get the user's current timezone offset from UTC as a string (e.g., "-05:00", "+01:00")
  String getUserTimeZoneOffset() {
    final currentTimeZone = tz.getLocation(getUserTimeZone());
    final offsetInMilliseconds = currentTimeZone.currentTimeZone.offset;
    final offsetInSeconds = offsetInMilliseconds ~/ 1000;
    final hours = (offsetInSeconds ~/ 3600).abs();
    final minutes = ((offsetInSeconds % 3600) ~/ 60).abs();
    final sign = offsetInSeconds.isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Get the user's current timezone offset from UTC as a Duration
  Duration getUserTimeZoneOffsetDuration() {
    return DateTime.now().timeZoneOffset;
  }

  /// Convert a UTC DateTime to the user's timezone
  DateTime convertToUserTimeZone(DateTime utcTime) {
    initializeTimeZones();
    final timeZone = getUserTimeZone();
    final location = tz.getLocation(timeZone);
    return tz.TZDateTime.from(utcTime, location);
  }

  /// Get a TZDateTime for the current time in the user's timezone
  tz.TZDateTime getCurrentTimeInUserTimeZone() {
    initializeTimeZones();
    final timeZone = getUserTimeZone();
    final location = tz.getLocation(timeZone);
    return tz.TZDateTime.now(location);
  }

  /// Check if the timezone is being overridden by arguments
  bool get isTimeZoneOverridden => arguments.location != null && arguments.location!.isNotEmpty;
}
