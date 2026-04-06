import 'package:flutter/material.dart';

class WidgetFrameSize {
  WidgetFrameSize({required this.name, required this.width, required this.height, this.backgroundColor = Colors.white});

  final String name;
  final double width;
  final double height;
  final Color backgroundColor;
}
