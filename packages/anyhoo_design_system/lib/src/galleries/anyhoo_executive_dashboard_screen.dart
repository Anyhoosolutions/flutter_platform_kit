import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Composition screen: metrics, actions, and a users table.
class AnyhooExecutiveDashboardScreen extends StatelessWidget {
  AnyhooExecutiveDashboardScreen({super.key});

  final _destinations = [
    AnyhooBottomBarButton(icon: Icons.dashboard_outlined, label: 'Dashboard', onTap: () {}),
    AnyhooBottomBarButton(icon: Icons.widgets_outlined, label: 'Components', onTap: () {}),
    AnyhooBottomBarButton(icon: Icons.forum_outlined, label: 'Feedback', onTap: () {}),
    AnyhooBottomBarButton(icon: Icons.palette_outlined, label: 'Design', onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return Scaffold(
      body: Column(
        children: [
          AnyhooTopBar(topBarTitle: 'Overview'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(DesignTokens.marginMobile),
              children: [
                'Executive Overview'.display(size: DisplaySize.medium),
                const SizedBox(height: DesignTokens.spacingXs),
                'Performance metrics for Q3.'.body(size: BodySize.large),
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
                      'Quick Actions'.headline(size: HeadlineSize.small),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.cloud_download, size: 18, color: accent.primaryFixed),
                            label: Text('Export Data', style: TextStyle(color: accent.primaryFixed)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: BorderSide(color: surface.cardBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.settings, size: 18, color: accent.primaryFixed),
                            label: Text('Configure', style: TextStyle(color: accent.primaryFixed)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: BorderSide(color: surface.cardBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                'Recent System Users'.headline(size: HeadlineSize.small),
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
                      ).pad(h: 8),
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
                              style: TextStyle(color: surface.secondaryText, fontWeight: FontWeight.bold, fontSize: 12),
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
                      ).pad(h: 8),
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
                              style: TextStyle(color: surface.secondaryText, fontWeight: FontWeight.bold, fontSize: 12),
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
                      ).pad(h: 8),
                      'Yesterday',
                    ],
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXl),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnyhooBottomBar(destinations: _destinations, selectedIndex: 0),
    );
  }
}
