import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of banners, dialogs, and toasts.
class AnyhooFeedbackGallery extends StatefulWidget {
  const AnyhooFeedbackGallery({super.key});

  @override
  State<AnyhooFeedbackGallery> createState() => _AnyhooFeedbackGalleryState();
}

class _AnyhooFeedbackGalleryState extends State<AnyhooFeedbackGallery> {
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Banner'.headline(size: HeadlineSize.small).pad(b: 4),
            if (_showBanner)
              AnyhooBanner(
                title: 'System Update Available',
                message:
                    'A new version of the design system components is ready. Review changes before updating your local files.',
                onDismiss: () => setState(() => _showBanner = false),
              )
            else
              TextButton(
                onPressed: () => setState(() => _showBanner = true),
                child: const Text('Show banner again'),
              ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Dialog'.headline(size: HeadlineSize.small).pad(b: 4),
            ColoredBox(
              color: surface.containerLow,
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: Center(
                  child: AnyhooDialog(
                    title: 'Discard draft?',
                    message:
                        'This action cannot be undone. All unsaved changes will be lost permanently.',
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Discard',
                    destructive: true,
                    onCancel: () {},
                    onConfirm: () {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  AnyhooDialog.show(
                    context: context,
                    title: 'Discard draft?',
                    message:
                        'This action cannot be undone. All unsaved changes will be lost permanently.',
                    confirmLabel: 'Discard',
                    destructive: true,
                    onConfirm: () {},
                  );
                },
                child: const Text('Show as modal'),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Toast'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooToast(
              message: 'Changes saved successfully',
              actionLabel: 'Undo',
              onAction: () {},
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  AnyhooToast.show(
                    context,
                    message: 'Changes saved successfully',
                    actionLabel: 'Undo',
                    onAction: () {},
                  );
                },
                child: const Text('Show via ScaffoldMessenger'),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
