import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic dialog content (title, body, cancel + confirm actions).
///
/// Use [AnyhooDialog.show] to present it as a modal, or embed the widget
/// directly (e.g. in Widgetbook).
class AnyhooDialog extends StatelessWidget {
  const AnyhooDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.leadingIcon = Icons.warning_amber_rounded,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String cancelLabel;
  final VoidCallback? onCancel;
  final IconData? leadingIcon;
  final bool destructive;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    String cancelLabel = 'Cancel',
    VoidCallback? onCancel,
    IconData? leadingIcon = Icons.warning_amber_rounded,
    bool destructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
          child: AnyhooDialog(
            title: title,
            message: message,
            confirmLabel: confirmLabel,
            onConfirm: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            cancelLabel: cancelLabel,
            onCancel: () {
              Navigator.of(dialogContext).pop();
              onCancel?.call();
            },
            leadingIcon: leadingIcon,
            destructive: destructive,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final status = context.status;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surface.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          border: Border.all(color: surface.cardBorder.withValues(alpha: 0.5)),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 8), blurRadius: 24),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leadingIcon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spacingSm),
                      decoration: BoxDecoration(
                        color: status.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(leadingIcon, color: status.error, size: 24),
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AnyhooTypography.headline(HeadlineSize.small).copyWith(
                            color: surface.primaryText,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingSm),
                        Text(
                          message,
                          style: AnyhooTypography.body(BodySize.medium).copyWith(
                            color: surface.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: accent.primaryFixed,
                      minimumSize: const Size(48, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                      ),
                    ),
                    child: Text(
                      cancelLabel,
                      style: AnyhooTypography.label(LabelSize.large),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  FilledButton(
                    onPressed: onConfirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: destructive ? DesignTokens.errorRed : accent.primaryFixed,
                      foregroundColor: destructive ? DesignTokens.onError : accent.onPrimaryFixed,
                      minimumSize: const Size(48, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                      ),
                    ),
                    child: Text(
                      confirmLabel,
                      style: AnyhooTypography.label(LabelSize.large),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
