import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({required String label, required IconData? icon, required VoidCallback onTap}) = _MenuItem;
}
