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
    AnyhooDropdownOption(value: 'elevated', label: 'ElevatedButton'),
    AnyhooDropdownOption(value: 'filled', label: 'FilledButton'),
    AnyhooDropdownOption(value: 'text', label: 'TextButton'),
    AnyhooDropdownOption(value: 'outlined', label: 'OutlinedButton'),
  ];

  static const _animals = [
    AnyhooDropdownOption(value: 'dog', label: 'Dog'),
    AnyhooDropdownOption(value: 'cat', label: 'Cat'),
    AnyhooDropdownOption(value: 'bird', label: 'Bird'),
    AnyhooDropdownOption(value: 'cow', label: 'Cow'),
    AnyhooDropdownOption(value: 'pig', label: 'Pig'),
    AnyhooDropdownOption(value: 'chicken', label: 'Chicken'),
  ];

  String? _singleValue = 'elevated';
  List<String> _multiFew = const ['dog', 'cat'];
  List<String> _multiMany = const ['dog', 'cat', 'bird', 'cow', 'pig'];
  String? _addableSingle;
  List<AnyhooDropdownOption<String>> _addableSingleOptions = List.of(_widgetTypes);
  List<String> _addableMulti = const [];
  List<AnyhooDropdownOption<String>> _addableMultiOptions = List.of(_animals);

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
              'Shared arguments: options (List<AnyhooDropdownOption<T>>), label, hint, onChanged, '
              'optional onCreate (shows the add-new footer), maxVisibleOptions, maxWidth. '
              'Multi shows up to 3 chips; if there are more, the last chip is "+N items" and is not deletable. '
              'The menu opens below the field, or above when there is not enough space. '
              'Search, option icons, and grouped categories are not in this phase.',
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
