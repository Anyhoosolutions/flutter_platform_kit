import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_item.freezed.dart';

@freezed
abstract class AnyhooTopBarButtonItem with _$AnyhooTopBarButtonItem {
  const factory AnyhooTopBarButtonItem({
    required Key key,
    required String label,
    required IconData? icon,
    required VoidCallback onTap,
    @Default(null) Color? color,
  }) = _AnyhooTopBarButtonItem;
}
