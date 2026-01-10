import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class Utils {
  static String generateRandomString(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  static String hash(String input) {
    // Convert the input string to bytes
    List<int> bytes = utf8.encode(input);

    // Compute the SHA-256 hash
    Digest digest = sha256.convert(bytes);

    // Convert the hash to a hexadecimal string
    return digest.toString().substring(20);
  }
}
