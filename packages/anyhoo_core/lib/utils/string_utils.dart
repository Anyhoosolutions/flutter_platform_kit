import 'dart:math';

class AnyhooStringUtils {
  static String generateRandomString(
    int length, {
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecial = false,
  }) {
    String chars = '';
    if (includeUppercase) {
      chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    }
    if (includeLowercase) {
      chars += 'abcdefghijklmnopqrstuvwxyz';
    }
    if (includeNumbers) {
      chars += '0123456789';
    }
    if (includeSpecial) {
      chars += '!@#%^&*()_-';
    }
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
