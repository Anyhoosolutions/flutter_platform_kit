import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_button_info.freezed.dart';

@freezed
sealed class ActionButtonInfo with _$ActionButtonInfo {
  const factory ActionButtonInfo.normal({
    required IconData icon,
    required Null Function() onTap,
    required String name,
  }) = NormalActionButtonInfo;
  const factory ActionButtonInfo.overflow({
    required IconData icon,
    required Null Function() onTap,
    required String title,
  }) = OverflowActionButtonInfo;
  const factory ActionButtonInfo.divider() = DividerActionButtonInfo;
}
