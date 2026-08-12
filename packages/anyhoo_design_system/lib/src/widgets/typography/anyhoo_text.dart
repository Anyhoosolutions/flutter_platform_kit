import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Shared text renderer for Kinetic Logic typography widgets.
class _AnyhooText extends StatelessWidget {
  const _AnyhooText({
    required this.data,
    required this.style,
    required this.defaultColor,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String data;
  final TextStyle style;
  final Color defaultColor;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style.copyWith(color: color ?? defaultColor),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

/// Display text (hero / page-level titles).
class AnyhooDisplay extends StatelessWidget {
  const AnyhooDisplay(
    this.data, {
    super.key,
    this.size = DisplaySize.medium,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String data;
  final DisplaySize size;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return _AnyhooText(
      data: data,
      style: AnyhooTypography.display(size),
      defaultColor: context.surface.primaryText,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

/// Headline text for section and card titles.
class AnyhooHeadline extends StatelessWidget {
  const AnyhooHeadline(
    this.data, {
    super.key,
    this.size = HeadlineSize.medium,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String data;
  final HeadlineSize size;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return _AnyhooText(
      data: data,
      style: AnyhooTypography.headline(size),
      defaultColor: context.surface.primaryText,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

/// Body copy for paragraphs and supporting text.
///
/// Defaults to [SurfaceColors.secondaryText] (`on-surface-variant`).
class AnyhooBody extends StatelessWidget {
  const AnyhooBody(
    this.data, {
    super.key,
    this.size = BodySize.medium,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String data;
  final BodySize size;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return _AnyhooText(
      data: data,
      style: AnyhooTypography.body(size),
      defaultColor: context.surface.secondaryText,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

/// Labels for buttons, chips, overlines, and metadata.
class AnyhooLabel extends StatelessWidget {
  const AnyhooLabel(
    this.data, {
    super.key,
    this.size = LabelSize.medium,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String data;
  final LabelSize size;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return _AnyhooText(
      data: data,
      style: AnyhooTypography.label(size),
      defaultColor: context.surface.primaryText,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}
