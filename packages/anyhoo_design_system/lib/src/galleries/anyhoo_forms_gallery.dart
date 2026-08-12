import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of search, segmented control, sliders, and date picker.
class AnyhooFormsGallery extends StatefulWidget {
  const AnyhooFormsGallery({super.key});

  @override
  State<AnyhooFormsGallery> createState() => _AnyhooFormsGalleryState();
}

class _AnyhooFormsGalleryState extends State<AnyhooFormsGallery> {
  String _segment = 'day';
  double _volume = 65;
  double _brightness = 40;
  DateTime _date = DateTime(2023, 10, 24);

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Search Input'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: AnyhooSearchField(
                hint: 'Search...',
                onFilterTap: () {},
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Segmented Control'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: AnyhooSegmentedControl<String>(
                selected: _segment,
                onChanged: (value) => setState(() => _segment = value),
                segments: const [
                  AnyhooSegment(label: 'Day', value: 'day'),
                  AnyhooSegment(label: 'Week', value: 'week'),
                  AnyhooSegment(label: 'Month', value: 'month'),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Range Sliders'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                children: [
                  AnyhooSlider(
                    value: _volume,
                    min: 0,
                    max: 100,
                    onChanged: (value) => setState(() => _volume = value),
                    leadingIcon: Icons.volume_down,
                    trailingIcon: Icons.volume_up,
                  ),
                  const SizedBox(height: DesignTokens.spacingLg),
                  AnyhooSlider(
                    value: _brightness,
                    min: 0,
                    max: 100,
                    onChanged: (value) => setState(() => _brightness = value),
                    leadingIcon: Icons.brightness_low,
                    trailingIcon: Icons.brightness_high,
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Date Picker'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                children: [
                  AnyhooDateField(
                    date: _date,
                    onTap: () {},
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  AnyhooCalendar(
                    selectedDate: _date,
                    onDateSelected: (value) => setState(() => _date = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
