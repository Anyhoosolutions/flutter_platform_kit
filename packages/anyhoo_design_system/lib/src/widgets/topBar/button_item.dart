import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_item.freezed.dart';

@freezed
abstract class ButtonItem with _$ButtonItem {
  const factory ButtonItem({
    required Key key,
    required String label,
    required IconData? icon,
    required VoidCallback onTap,
    @Default(null) Color? color,
  }) = _MenuItem;
}
