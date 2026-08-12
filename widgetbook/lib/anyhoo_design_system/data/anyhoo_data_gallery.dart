import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Gallery', type: AnyhooDataTable, path: 'anyhoo_design_system/data')
Widget buildAnyhooDataGallery(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const _DataGallery());
}

class _DataGallery extends StatefulWidget {
  const _DataGallery();

  @override
  State<_DataGallery> createState() => _DataGalleryState();
}

class _DataGalleryState extends State<_DataGallery> {
  bool _sync = true;
  final Set<String> _filters = {'selected'};

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'System Users'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooDataTable(
              columns: const ['ID', 'Name', 'Role', 'Status'],
              rows: [
                [
                  'USR-001',
                  'Elena Rostova',
                  'Admin',
                  const AnyhooChip(
                    label: 'Active',
                    variant: AnyhooChipVariant.primary,
                    shape: AnyhooChipShape.pill,
                  ),
                ],
                [
                  'USR-002',
                  'Marcus Vance',
                  'Editor',
                  const AnyhooChip(
                    label: 'Pending',
                    variant: AnyhooChipVariant.secondary,
                    shape: AnyhooChipShape.pill,
                  ),
                ],
                [
                  'USR-003',
                  'Sarah Jenkins',
                  'Viewer',
                  const AnyhooChip(
                    label: 'Inactive',
                    variant: AnyhooChipVariant.neutral,
                    shape: AnyhooChipShape.pill,
                  ),
                ],
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Indicators & Tags'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Status Badges'.label(size: LabelSize.large, color: surface.secondaryText),
                  const SizedBox(height: DesignTokens.spacingSm),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AnyhooChip(label: 'Primary', shape: AnyhooChipShape.pill, variant: AnyhooChipVariant.secondary),
                      AnyhooChip(label: 'Secondary', shape: AnyhooChipShape.pill, variant: AnyhooChipVariant.secondary),
                      AnyhooChip(label: 'Neutral', shape: AnyhooChipShape.pill, variant: AnyhooChipVariant.neutral),
                      AnyhooChip(label: 'Alert', shape: AnyhooChipShape.pill, variant: AnyhooChipVariant.alert),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  'Filter Chips'.label(size: LabelSize.large, color: surface.secondaryText),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AnyhooFilterChip(
                        label: 'Selected',
                        selected: _filters.contains('selected'),
                        onSelected: (v) => setState(() {
                          v ? _filters.add('selected') : _filters.remove('selected');
                        }),
                      ),
                      AnyhooFilterChip(
                        label: 'Default Filter',
                        selected: _filters.contains('default'),
                        onSelected: (v) => setState(() {
                          v ? _filters.add('default') : _filters.remove('default');
                        }),
                      ),
                      AnyhooFilterChip(
                        label: 'Another Filter',
                        selected: _filters.contains('another'),
                        onSelected: (v) => setState(() {
                          v ? _filters.add('another') : _filters.remove('another');
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  'Notification Dots'.label(size: LabelSize.large, color: surface.secondaryText),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Row(
                    children: [
                      AnyhooNotificationBadge(
                        showDot: true,
                        child: _IconWell(icon: Icons.notifications_outlined, color: surface.secondaryText),
                      ),
                      const SizedBox(width: DesignTokens.spacingLg),
                      AnyhooNotificationBadge(
                        count: 3,
                        child: _IconWell(icon: Icons.mail_outline, color: surface.secondaryText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'System Preferences'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooList(
              title: 'System Preferences',
              children: [
                AnyhooListItem(
                  leadingIcon: Icons.manage_accounts_outlined,
                  leadingBackground: accent.primaryContainer.withValues(alpha: 0.1),
                  title: 'Account Management',
                  subtitle: 'Update profile, password, and security settings',
                  onTap: () {},
                ),
                AnyhooListItem(
                  leadingIcon: Icons.sync,
                  leadingBackground: surface.secondaryContainer.withValues(alpha: 0.3),
                  title: 'Data Synchronization',
                  subtitle: 'Manage offline access and background sync intervals',
                  showChevron: false,
                  trailing: AnyhooSwitch(
                    value: _sync,
                    onChanged: (v) => setState(() => _sync = v),
                  ),
                ),
                AnyhooListItem(
                  leadingIcon: Icons.shield_outlined,
                  leadingBackground: surface.containerHigh,
                  title: 'Privacy & Permissions',
                  subtitle: 'Control application access to system resources',
                  showChevron: false,
                  trailing: const AnyhooChip(label: 'Review', variant: AnyhooChipVariant.neutral),
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

class _IconWell extends StatelessWidget {
  const _IconWell({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surface.containerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingSm),
        child: Icon(icon, color: color),
      ),
    );
  }
}
