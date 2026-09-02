import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Overview', type: AnyhooDropdown, path: 'anyhoo_design_system/forms')
Widget buildAnyhooDropdownOverview(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const _DropdownOverviewPage());
}

class _DropdownOverviewPage extends StatefulWidget {
  const _DropdownOverviewPage();

  @override
  State<_DropdownOverviewPage> createState() => _DropdownOverviewPageState();
}

class _DropdownOverviewPageState extends State<_DropdownOverviewPage> {
  static const _widgetTypes = [
    AnyhooDropdownOption(value: 'elevated', label: 'ElevatedButton', icon: Icons.layers),
    AnyhooDropdownOption(value: 'filled', label: 'FilledButton', icon: Icons.rectangle),
    AnyhooDropdownOption(value: 'text', label: 'TextButton', icon: Icons.text_fields),
    AnyhooDropdownOption(value: 'outlined', label: 'OutlinedButton', icon: Icons.crop_square),
  ];

  static const _animals = [
    AnyhooDropdownOption(value: 'dog', label: 'Dog', icon: Icons.pets),
    AnyhooDropdownOption(value: 'cat', label: 'Cat', icon: Icons.pets),
    AnyhooDropdownOption(value: 'bird', label: 'Bird', icon: Icons.flutter_dash),
    AnyhooDropdownOption(value: 'cow', label: 'Cow', icon: Icons.grass),
    AnyhooDropdownOption(value: 'pig', label: 'Pig', icon: Icons.agriculture),
    AnyhooDropdownOption(value: 'chicken', label: 'Chicken', icon: Icons.egg),
  ];

  static const _groupedAnimals = [
    AnyhooDropdownGroup(
      title: 'Pets',
      options: [
        AnyhooDropdownOption(value: 'dog', label: 'Dog', icon: Icons.pets),
        AnyhooDropdownOption(value: 'cat', label: 'Cat', icon: Icons.pets),
        AnyhooDropdownOption(value: 'bird', label: 'Bird', icon: Icons.flutter_dash),
      ],
    ),
    AnyhooDropdownGroup(
      title: 'Farm',
      options: [
        AnyhooDropdownOption(value: 'cow', label: 'Cow', icon: Icons.grass),
        AnyhooDropdownOption(value: 'pig', label: 'Pig', icon: Icons.agriculture),
        AnyhooDropdownOption(value: 'chicken', label: 'Chicken', icon: Icons.egg),
      ],
    ),
  ];

  String? _singleValue = 'elevated';
  List<String> _multiFew = const ['dog', 'cat'];
  List<String> _multiMany = const ['dog', 'cat', 'bird', 'cow', 'pig'];
  String? _addableSingle;
  List<AnyhooDropdownOption<String>> _addableSingleOptions = List.of(_widgetTypes);
  List<String> _addableMulti = const [];
  List<AnyhooDropdownOption<String>> _addableMultiOptions = List.of(_animals);
  String? _searchValue = 'elevated';
  List<String> _groupedMulti = const ['dog'];
  String? _groupedSingle = 'cat';

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'AnyhooDropdown'.headline(size: HeadlineSize.small).pad(b: 8),
            Text(
              'One overlay dropdown for single and multi selection. '
              'Constructors: AnyhooDropdown.single (T? value) and AnyhooDropdown.multi (List<T> value). '
              'Pass either options or groups (not both). AnyhooDropdownOption has value, label, and optional icon. '
              'Shared arguments: label, hint, onChanged, searchEnabled, optional onCreate (add-new footer; not with groups), '
              'maxVisibleOptions, maxWidth. '
              'Multi shows up to 3 chips; if there are more, the last chip is "+N items" and is not deletable. '
              'The menu opens below the field, or above when there is not enough space.',
              style: AnyhooTypography.body(BodySize.medium).copyWith(color: surface.secondaryText),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            _section(
              title: 'Single',
              description: 'AnyhooDropdown.single — one value, overlay closes on pick, check on the selected row.',
              child: AnyhooDropdown<String>.single(
                label: 'Widget type',
                value: _singleValue,
                options: _widgetTypes,
                onChanged: (value) => setState(() => _singleValue = value),
              ),
            ),
            _section(
              title: 'Multi (few)',
              description: 'AnyhooDropdown.multi — overlay stays open. Chips are deletable.',
              child: AnyhooDropdown<String>.multi(
                label: 'Animals',
                value: _multiFew,
                options: _animals,
                onChanged: (value) => setState(() => _multiFew = value),
              ),
            ),
            _section(
              title: 'Multi (overflow chips)',
              description: 'More than 3 selected: two chips plus "+N items". The overflow chip cannot be deleted.',
              child: AnyhooDropdown<String>.multi(
                label: 'Animals',
                value: _multiMany,
                options: _animals,
                onChanged: (value) => setState(() => _multiMany = value),
              ),
            ),
            _section(
              title: 'Single + onCreate',
              description: 'Pass onCreate to show the footer. Parent owns the options list; create then select and close.',
              child: AnyhooDropdown<String>.single(
                label: 'Addable option property',
                value: _addableSingle,
                options: _addableSingleOptions,
                onChanged: (value) => setState(() => _addableSingle = value),
                onCreate: (name) {
                  setState(() {
                    _addableSingleOptions = [
                      ..._addableSingleOptions,
                      AnyhooDropdownOption(value: name, label: name),
                    ];
                  });
                  return name;
                },
              ),
            ),
            _section(
              title: 'Multi + onCreate',
              description: 'Same footer on multi: new items are appended to the selection and the overlay stays open.',
              child: AnyhooDropdown<String>.multi(
                label: 'Tags',
                value: _addableMulti,
                options: _addableMultiOptions,
                onChanged: (value) => setState(() => _addableMulti = value),
                onCreate: (name) {
                  setState(() {
                    _addableMultiOptions = [
                      ..._addableMultiOptions,
                      AnyhooDropdownOption(value: name, label: name),
                    ];
                  });
                  return name;
                },
              ),
            ),
            _section(
              title: 'Search',
              description: 'searchEnabled: true — filters options by label. Independent of the add-new footer.',
              child: AnyhooDropdown<String>.single(
                label: 'Widget type',
                value: _searchValue,
                options: _widgetTypes,
                searchEnabled: true,
                onChanged: (value) => setState(() => _searchValue = value),
              ),
            ),
            _section(
              title: 'Categories (single)',
              description: 'Pass groups instead of options. Headers are labels only. onCreate is not allowed.',
              child: AnyhooDropdown<String>.single(
                label: 'Animal',
                value: _groupedSingle,
                groups: _groupedAnimals,
                searchEnabled: true,
                onChanged: (value) => setState(() => _groupedSingle = value),
              ),
            ),
            _section(
              title: 'Categories (multi)',
              description: 'Same groups API on multi. Search hides empty groups.',
              child: AnyhooDropdown<String>.multi(
                label: 'Animals',
                value: _groupedMulti,
                groups: _groupedAnimals,
                searchEnabled: true,
                onChanged: (value) => setState(() => _groupedMulti = value),
              ),
            ),
            _section(
              title: 'Near the bottom',
              description: 'Scroll this field to the lower edge of the screen; the overlay should open above the field.',
              child: AnyhooDropdown<String>.single(
                label: 'Placement',
                value: _singleValue,
                options: _widgetTypes,
                onChanged: (value) => setState(() => _singleValue = value),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required String description, required Widget child}) {
    final surface = context.surface;
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title.headline(size: HeadlineSize.tiny).pad(b: 4),
          Text(
            description,
            style: AnyhooTypography.body(BodySize.medium).copyWith(color: surface.secondaryText),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          AnyhooCardShell(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: child,
          ),
        ],
      ),
    );
  }
}
