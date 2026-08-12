import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Convenience builders that turn a [String] into Kinetic Logic text widgets.
///
/// ```dart
/// 'Structured Hierarchy'.headline(size: HeadlineSize.medium)
/// ```
extension AnyhooStringTypography on String {
  Widget display({
    Key? key,
    DisplaySize size = DisplaySize.medium,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    bool? softWrap,
  }) {
    return AnyhooDisplay(
      this,
      key: key,
      size: size,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }

  Widget headline({
    Key? key,
    HeadlineSize size = HeadlineSize.medium,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    bool? softWrap,
  }) {
    return AnyhooHeadline(
      this,
      key: key,
      size: size,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }

  Widget body({
    Key? key,
    BodySize size = BodySize.medium,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    bool? softWrap,
  }) {
    return AnyhooBody(
      this,
      key: key,
      size: size,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }

  Widget label({
    Key? key,
    LabelSize size = LabelSize.medium,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    bool? softWrap,
  }) {
    return AnyhooLabel(
      this,
      key: key,
      size: size,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}
