import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHexString({String delimiter = '', bool zeroXprefix = false, bool withAlpha = false}) {
    return '${zeroXprefix ? '0x' : '#'}${withAlpha ? a.toInt().toRadixString(16).padLeft(2, '0') : ''}$delimiter${r.toInt().toRadixString(16).padLeft(2, '0')}$delimiter${g.toInt().toRadixString(16).padLeft(2, '0')}$delimiter${b.toInt().toRadixString(16).padLeft(2, '0')}';
  }
}
