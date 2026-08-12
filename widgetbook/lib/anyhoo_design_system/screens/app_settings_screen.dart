import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'App Settings', type: AnyhooList, path: 'anyhoo_design_system/screens')
Widget buildAppSettingsScreen(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    const _AppSettingsScreen(),
  );
}

class _AppSettingsScreen extends StatefulWidget {
  const _AppSettingsScreen();

  @override
  State<_AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<_AppSettingsScreen> {
  bool _darkMode = true;
  String _language = 'en';
  double _volume = 50;

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD85TfYVe4kkVorC36HeCjWz_vrd2GD2G-sdRkJTTi1JIBVVReQ7RIif25yTw5oqPIqnJYe2kg0B6ctoQwzsIPeF4MrRJINhO1FXH-Ygx12jn8XcdhCftQzZRXMGo-7-J9ka1qEcJ63SZuhMTUnzgz1zx4gUgKpNnUFiICwu2ULJjRSHz18kmFedox-ek82oPrY4v1OaOUHOEI5xlPbiYo3z33l5NJxUcw0qAJlwygZIuOIPh9Gm_Vj';

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final status = context.status;

    return ColoredBox(
      color: surface.scaffoldBackground,
      child: Column(
        children: [
          const AnyhooTopBar(topBarText: 'Settings', showBackButton: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(DesignTokens.marginMobile),
              children: [
                AnyhooCardShell(
                  padding: const EdgeInsets.all(DesignTokens.spacingMd),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          _avatarUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => CircleAvatar(
                            radius: 32,
                            backgroundColor: surface.containerHigh,
                            child: Icon(Icons.person, color: accent.primaryFixed),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alex Sterling',
                              style: AnyhooTypography.headline(HeadlineSize.medium).copyWith(
                                color: surface.primaryText,
                              ),
                            ),
                            Text(
                              'alex.sterling@example.com',
                              style: AnyhooTypography.body(BodySize.medium).copyWith(
                                color: surface.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Edit',
                          style: AnyhooTypography.label(LabelSize.medium).copyWith(
                            color: accent.primaryFixed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                _SectionLabel('Account'),
                AnyhooList(
                  children: [
                    AnyhooListItem(
                      leadingIcon: Icons.person_outline,
                      leadingBackground: surface.containerHigh,
                      leadingCircular: true,
                      title: 'Personal Information',
                      subtitle: 'Update your details',
                      onTap: () {},
                    ),
                    AnyhooListItem(
                      leadingIcon: Icons.security,
                      leadingBackground: surface.containerHigh,
                      leadingCircular: true,
                      title: 'Security & Password',
                      subtitle: 'Manage credentials',
                      onTap: () {},
                    ),
                    AnyhooListItem(
                      leadingIcon: Icons.credit_card,
                      leadingBackground: surface.containerHigh,
                      leadingCircular: true,
                      title: 'Billing',
                      subtitle: 'Payment methods',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                _SectionLabel('Preferences'),
                AnyhooCardShell(
                  child: Column(
                    children: [
                      AnyhooListItem(
                        leadingIcon: Icons.dark_mode_outlined,
                        leadingBackground: surface.containerHigh,
                        leadingCircular: true,
                        title: 'Dark Mode',
                        subtitle: 'Adjust app theme',
                        showChevron: false,
                        trailing: AnyhooSwitch(
                          value: _darkMode,
                          onChanged: (v) => setState(() => _darkMode = v),
                        ),
                      ),
                      Divider(height: 1, color: surface.cardBorder.withValues(alpha: 0.3)),
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.spacingMd),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: surface.containerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(DesignTokens.spacingSm),
                                    child: Icon(Icons.language, color: accent.primaryFixed),
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.spacingMd),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Language',
                                        style: AnyhooTypography.label(LabelSize.large).copyWith(
                                          color: surface.primaryText,
                                        ),
                                      ),
                                      Text(
                                        'Select interface language',
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
                            AnyhooSegmentedControl<String>(
                              selected: _language,
                              onChanged: (v) => setState(() => _language = v),
                              segments: const [
                                AnyhooSegment(label: 'English', value: 'en'),
                                AnyhooSegment(label: 'Spanish', value: 'es'),
                                AnyhooSegment(label: 'German', value: 'de'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: surface.cardBorder.withValues(alpha: 0.3)),
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.spacingMd),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: surface.containerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(DesignTokens.spacingSm),
                                    child: Icon(Icons.notifications_outlined, color: accent.primaryFixed),
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.spacingMd),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Notification Volume',
                                        style: AnyhooTypography.label(LabelSize.large).copyWith(
                                          color: surface.primaryText,
                                        ),
                                      ),
                                      Text(
                                        'Adjust alert frequency',
                                        style: AnyhooTypography.body(BodySize.medium).copyWith(
                                          color: surface.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: DesignTokens.spacingSm),
                            AnyhooSlider(
                              value: _volume,
                              min: 0,
                              max: 100,
                              onChanged: (v) => setState(() => _volume = v),
                              leadingIcon: Icons.notifications_off_outlined,
                              trailingIcon: Icons.notifications_active_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                _SectionLabel('Support'),
                AnyhooList(
                  children: [
                    AnyhooListItem(
                      leadingIcon: Icons.help_outline,
                      leadingBackground: surface.containerHigh,
                      leadingCircular: true,
                      title: 'Help Center',
                      onTap: () {},
                    ),
                    AnyhooListItem(
                      leadingIcon: Icons.info_outline,
                      leadingBackground: surface.containerHigh,
                      leadingCircular: true,
                      title: 'About',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXl),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.logout, color: status.error),
                  label: Text(
                    'Log Out',
                    style: AnyhooTypography.label(LabelSize.large).copyWith(color: status.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(color: DesignTokens.errorRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: DesignTokens.spacingSm,
        bottom: DesignTokens.spacingSm,
      ),
      child: Text(
        label,
        style: AnyhooTypography.label(LabelSize.large).copyWith(
          color: context.surface.secondaryText,
        ),
      ),
    );
  }
}
