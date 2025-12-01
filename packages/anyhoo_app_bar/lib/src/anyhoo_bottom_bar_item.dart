import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'anyhoo_bottom_bar_item.freezed.dart';

@freezed
abstract class AnyhooBottomBarItem with _$AnyhooBottomBarItem {
  const factory AnyhooBottomBarItem({
    required String key,
    required String label,
    required IconData icon,
    required String route,
  }) = _AnyhooBottomBarItem;
}
