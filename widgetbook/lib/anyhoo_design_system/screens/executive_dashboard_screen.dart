import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Executive Dashboard', type: AnyhooMetricCard, path: 'anyhoo_design_system/screens')
Widget buildExecutiveDashboardScreen(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    const _ExecutiveDashboardScreen(),
  );
}

class _ExecutiveDashboardScreen extends StatelessWidget {
  const _ExecutiveDashboardScreen();

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return ColoredBox(
      color: surface.scaffoldBackground,
      child: Column(
        children: [
          AnyhooTopBar(topBarText: 'Overview'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(DesignTokens.marginMobile),
              children: [
                Text(
                  'Executive Overview',
                  style: AnyhooTypography.display(DisplaySize.medium).copyWith(
                    color: surface.primaryText,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  'Performance metrics for Q3.',
                  style: AnyhooTypography.body(BodySize.large).copyWith(
                    color: surface.secondaryText,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                AnyhooMetricCard(
                  label: 'Engagement',
                  value: '42.8k',
                  icon: Icons.insights,
                  badgeLabel: '+12.4%',
                  minHeight: 160,
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                AnyhooMetricCard(
                  label: 'Revenue',
                  value: '\$1.2M',
                  icon: Icons.account_balance_wallet_outlined,
                  badgeLabel: '+8.1%',
                  minHeight: 160,
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                AnyhooCardShell(
                  padding: const EdgeInsets.all(DesignTokens.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AnyhooTypography.headline(HeadlineSize.small).copyWith(
                          color: surface.primaryText,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingMd),
                      Wrap(
                        spacing: DesignTokens.spacingMd,
                        runSpacing: DesignTokens.spacingSm,
                        children: [
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('New Report'),
                            style: FilledButton.styleFrom(
                              backgroundColor: accent.primaryFixed,
                              foregroundColor: accent.onPrimaryFixed,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.cloud_download, size: 18, color: accent.primaryFixed),
                            label: Text(
                              'Export Data',
                              style: TextStyle(color: accent.primaryFixed),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: BorderSide(color: surface.cardBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.settings, size: 18, color: accent.primaryFixed),
                            label: Text(
                              'Configure',
                              style: TextStyle(color: accent.primaryFixed),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: BorderSide(color: surface.cardBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                Text(
                  'Recent System Users',
                  style: AnyhooTypography.headline(HeadlineSize.small).copyWith(
                    color: surface.primaryText,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                AnyhooDataTable(
                  columns: const ['User', 'Role', 'Status', 'Last Active'],
                  rows: [
                    [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: accent.primaryContainer,
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: accent.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Alice Smith')),
                        ],
                      ),
                      'Administrator',
                      const AnyhooChip(
                        label: 'Active',
                        variant: AnyhooChipVariant.secondary,
                        shape: AnyhooChipShape.pill,
                      ),
                      '2 mins ago',
                    ],
                    [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: surface.containerHighest,
                            child: Text(
                              'B',
                              style: TextStyle(
                                color: surface.secondaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Bob Jones')),
                        ],
                      ),
                      'Analyst',
                      const AnyhooChip(
                        label: 'Active',
                        variant: AnyhooChipVariant.secondary,
                        shape: AnyhooChipShape.pill,
                      ),
                      '1 hr ago',
                    ],
                    [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: surface.containerHighest,
                            child: Text(
                              'C',
                              style: TextStyle(
                                color: surface.secondaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Charlie Day')),
                        ],
                      ),
                      'Viewer',
                      const AnyhooChip(
                        label: 'Offline',
                        variant: AnyhooChipVariant.neutral,
                        shape: AnyhooChipShape.pill,
                      ),
                      'Yesterday',
                    ],
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXl),
              ],
            ),
          ),
          _ScreenBottomNav(selectedIndex: 0, labels: const ['Dashboard', 'Components', 'Feedback', 'Design']),
        ],
      ),
    );
  }
}

class _ScreenBottomNav extends StatelessWidget {
  const _ScreenBottomNav({required this.selectedIndex, required this.labels});

  final int selectedIndex;
  final List<String> labels;

  static const _icons = [
    Icons.dashboard_outlined,
    Icons.widgets_outlined,
    Icons.forum_outlined,
    Icons.palette_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return Material(
      color: surface.bottomBarBackground,
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: surface.cardBorder)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: i == selectedIndex ? surface.secondaryContainer : Colors.transparent,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icons[i],
                              size: 20,
                              color: i == selectedIndex
                                  ? surface.onSecondaryContainer
                                  : surface.secondaryText,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              labels[i],
                              style: AnyhooTypography.label(LabelSize.medium).copyWith(
                                color: i == selectedIndex
                                    ? surface.onSecondaryContainer
                                    : surface.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
