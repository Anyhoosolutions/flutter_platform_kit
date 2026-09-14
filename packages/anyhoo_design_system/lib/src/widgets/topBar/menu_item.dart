import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

@freezed
abstract class AnyhooTopBarMenuItem with _$AnyhooTopBarMenuItem {
  const factory AnyhooTopBarMenuItem({
    required Key key,
    required String label,
    required IconData? icon,
    required VoidCallback onTap,
  }) = _AnyhooTopBarMenuItem;
}
