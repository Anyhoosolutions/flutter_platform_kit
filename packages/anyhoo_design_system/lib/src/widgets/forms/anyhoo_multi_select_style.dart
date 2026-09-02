import 'package:flutter/material.dart';

/// Visual configuration for [AnyhooMultiSelect].
class AnyhooMultiSelectStyle {
  const AnyhooMultiSelectStyle({
    this.chipBackgroundColor,
    this.chipLabelStyle,
    this.chipDeleteIconColor,
    this.fieldDecoration,
    this.emptySelectionTextStyle,
    this.overlayBackgroundColor,
    this.overlayElevation = 4,
    this.overlayBorderRadius,
    this.overlayPadding = const EdgeInsets.all(8),
    this.searchFieldDecoration,
    this.searchHintText,
    this.sectionHeaderPadding = const EdgeInsets.fromLTRB(12, 12, 12, 4),
    this.sectionHeaderStyle,
    this.sectionHeaderBackgroundColor,
    this.itemTextStyle,
    this.checkboxActiveColor,
    this.overlayMaxHeight = 240,
    this.overlayFooter,
    this.closeOverlayButtonLabel,
    this.selectedTextStyle,
  });

  final Color? chipBackgroundColor;
  final TextStyle? chipLabelStyle;
  final Color? chipDeleteIconColor;
  final InputDecoration? fieldDecoration;
  final TextStyle? emptySelectionTextStyle;
  final Color? overlayBackgroundColor;
  final double overlayElevation;
  final BorderRadius? overlayBorderRadius;
  final EdgeInsets overlayPadding;
  final InputDecoration? searchFieldDecoration;
  final String? searchHintText;
  final EdgeInsets sectionHeaderPadding;
  final TextStyle? sectionHeaderStyle;
  final Color? sectionHeaderBackgroundColor;
  final TextStyle? itemTextStyle;
  final Color? checkboxActiveColor;
  final double overlayMaxHeight;
  final Widget? overlayFooter;
  final String? closeOverlayButtonLabel;
  final TextStyle? selectedTextStyle;

  static AnyhooMultiSelectStyle fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AnyhooMultiSelectStyle(
      chipBackgroundColor: colorScheme.primary,
      chipLabelStyle: TextStyle(color: colorScheme.onPrimary),
      chipDeleteIconColor: colorScheme.onPrimary,
      emptySelectionTextStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
      overlayBackgroundColor: colorScheme.surface,
      searchHintText: 'Search...',
      sectionHeaderStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      itemTextStyle: theme.textTheme.bodyLarge,
      checkboxActiveColor: colorScheme.primary,
      selectedTextStyle: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
    );
  }

  AnyhooMultiSelectStyle merge(AnyhooMultiSelectStyle? other) {
    if (other == null) return this;
    return AnyhooMultiSelectStyle(
      chipBackgroundColor: other.chipBackgroundColor ?? chipBackgroundColor,
      chipLabelStyle: other.chipLabelStyle ?? chipLabelStyle,
      chipDeleteIconColor: other.chipDeleteIconColor ?? chipDeleteIconColor,
      fieldDecoration: other.fieldDecoration ?? fieldDecoration,
      emptySelectionTextStyle: other.emptySelectionTextStyle ?? emptySelectionTextStyle,
      overlayBackgroundColor: other.overlayBackgroundColor ?? overlayBackgroundColor,
      overlayElevation: other.overlayElevation,
      overlayBorderRadius: other.overlayBorderRadius ?? overlayBorderRadius,
      overlayPadding: other.overlayPadding,
      searchFieldDecoration: other.searchFieldDecoration ?? searchFieldDecoration,
      searchHintText: other.searchHintText ?? searchHintText,
      sectionHeaderPadding: other.sectionHeaderPadding,
      sectionHeaderStyle: other.sectionHeaderStyle ?? sectionHeaderStyle,
      sectionHeaderBackgroundColor: other.sectionHeaderBackgroundColor ?? sectionHeaderBackgroundColor,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      checkboxActiveColor: other.checkboxActiveColor ?? checkboxActiveColor,
      overlayMaxHeight: other.overlayMaxHeight,
      overlayFooter: other.overlayFooter ?? overlayFooter,
      closeOverlayButtonLabel: other.closeOverlayButtonLabel ?? closeOverlayButtonLabel,
      selectedTextStyle: other.selectedTextStyle ?? selectedTextStyle,
    );
  }
}
