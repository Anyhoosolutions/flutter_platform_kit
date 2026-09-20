import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/controls/anyhoo_avatar.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of switches, checkboxes, radios, progress, and list items.
class AnyhooControlsGallery extends StatefulWidget {
  const AnyhooControlsGallery({super.key});

  @override
  State<AnyhooControlsGallery> createState() => _AnyhooControlsGalleryState();
}

class _AnyhooControlsGalleryState extends State<AnyhooControlsGallery> {
  bool _wifi = true;
  bool _rememberMe = true;
  String _radio = 'one';

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD85TfYVe4kkVorC36HeCjWz_vrd2GD2G-sdRkJTTi1JIBVVReQ7RIif25yTw5oqPIqnJYe2kg0B6ctoQwzsIPeF4MrRJINhO1FXH-Ygx12jn8XcdhCftQzZRXMGo-7-J9ka1qEcJ63SZuhMTUnzgz1zx4gUgKpNnUFiICwu2ULJjRSHz18kmFedox-ek82oPrY4v1OaOUHOEI5xlPbiYo3z33l5NJxUcw0qAJlwygZIuOIPh9Gm_Vj';

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Controls'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooCardShell(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingMd),
              child: Column(
                children: [
                  AnyhooSwitch(label: 'Wi-Fi', value: _wifi, onChanged: (value) => setState(() => _wifi = value)),
                  AnyhooCheckbox(
                    label: 'Remember me',
                    value: _rememberMe,
                    onChanged: (value) => setState(() => _rememberMe = value),
                  ),
                  AnyhooRadio<String>(
                    label: 'Option One',
                    value: 'one',
                    groupValue: _radio,
                    onChanged: (value) => setState(() => _radio = value!),
                  ),
                  AnyhooRadio<String>(
                    label: 'Option Two',
                    value: 'two',
                    groupValue: _radio,
                    onChanged: (value) => setState(() => _radio = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Avatars'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooCardShell(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingMd),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'With text'.body(),
                      AnyhooAvatar(text: 'AB', imageUrl: null),
                    ],
                  ).pad(h: 16, b: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'Selected with text'.body(),
                      AnyhooAvatar(text: 'AB', imageUrl: null, highlighted: true),
                    ],
                  ).pad(h: 16, b: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'With image'.body(),
                      AnyhooAvatar(text: null, imageUrl: _avatarUrl),
                    ],
                  ).pad(h: 16),
                ],
              ),
            ),

            'Progress & loaders'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      AnyhooCircularProgress(),
                      SizedBox(width: DesignTokens.spacingLg),
                      Expanded(child: AnyhooLinearProgress(value: 0.33)),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingLg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnyhooSkeleton(width: 60, height: 60, borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
                      const SizedBox(width: DesignTokens.spacingMd),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnyhooSkeleton(width: double.infinity, height: 16),
                            SizedBox(height: DesignTokens.spacingSm),
                            AnyhooSkeleton(width: 120, height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Settings list'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooList(
              title: 'Settings List',
              children: [
                AnyhooListItem(
                  leadingIcon: Icons.account_circle_outlined,
                  title: 'Profile Settings',
                  subtitle: 'Update your information',
                  onTap: () {},
                ),
                AnyhooListItem(
                  leadingIcon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage alert preferences',
                  onTap: () {},
                ),
                AnyhooListItem(
                  leadingIcon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control your data',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
