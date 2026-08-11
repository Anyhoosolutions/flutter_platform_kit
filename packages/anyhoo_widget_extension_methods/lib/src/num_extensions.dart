import 'package:flutter/material.dart';

extension NumExtension on num {
  // SizedBox generators
  Widget get kH => SizedBox(height: toDouble());
  Widget get kW => SizedBox(width: toDouble());

  // BorderRadius helpers
  BorderRadius get radius => BorderRadius.circular(toDouble());
}
