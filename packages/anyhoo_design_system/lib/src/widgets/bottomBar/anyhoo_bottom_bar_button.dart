import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'anyhoo_bottom_bar_button.freezed.dart';

@freezed
abstract class AnyhooBottomBarButton with _$AnyhooBottomBarButton {
  const factory AnyhooBottomBarButton({required String label, required IconData icon, required VoidCallback onTap}) =
      _AnyhooBottomBarButton;
}
