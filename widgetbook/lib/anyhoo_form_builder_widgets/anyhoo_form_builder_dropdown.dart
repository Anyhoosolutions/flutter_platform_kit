import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Overview', type: AnyhooFormBuilderDropdown, path: 'anyhoo_form_builder_widgets')
Widget buildAnyhooFormBuilderDropdownOverview(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const _FormBuilderDropdownPage());
}

class _FormBuilderDropdownPage extends StatefulWidget {
  const _FormBuilderDropdownPage();

  @override
  State<_FormBuilderDropdownPage> createState() => _FormBuilderDropdownPageState();
}

class _FormBuilderDropdownPageState extends State<_FormBuilderDropdownPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  static const _types = [
    AnyhooDropdownOption(value: 'elevated', label: 'ElevatedButton', icon: Icons.layers),
    AnyhooDropdownOption(value: 'filled', label: 'FilledButton', icon: Icons.rectangle),
    AnyhooDropdownOption(value: 'text', label: 'TextButton', icon: Icons.text_fields),
  ];

  static const _groups = [
    AnyhooDropdownGroup(
      title: 'Pets',
      options: [
        AnyhooDropdownOption(value: 'dog', label: 'Dog', icon: Icons.pets),
        AnyhooDropdownOption(value: 'cat', label: 'Cat', icon: Icons.pets),
      ],
    ),
    AnyhooDropdownGroup(
      title: 'Farm',
      options: [
        AnyhooDropdownOption(value: 'cow', label: 'Cow', icon: Icons.grass),
        AnyhooDropdownOption(value: 'pig', label: 'Pig', icon: Icons.agriculture),
      ],
    ),
  ];

  List<AnyhooDropdownOption<String>> _tags = const [
    AnyhooDropdownOption(value: 'design', label: 'Design'),
    AnyhooDropdownOption(value: 'dev', label: 'Dev'),
  ];

  String _saved = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'AnyhooFormBuilderDropdown wraps AnyhooDropdown in FormBuilderField. '
              'Use .single (T) or .multi (List<T>). Same options/groups/searchEnabled/onCreate '
              'as the design-system widget. name, initialValue, and validator are the form arguments.',
            ),
            const SizedBox(height: 16),
            AnyhooFormBuilderDropdown<String>.single(
              name: 'widgetType',
              label: 'Single',
              options: _types,
              initialValue: 'elevated',
              validator: (value) => value == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            AnyhooFormBuilderDropdown<String>.multi(
              name: 'tags',
              label: 'Multi + onCreate',
              options: _tags,
              initialValue: const ['design'],
              onCreate: (name) {
                setState(() {
                  _tags = [..._tags, AnyhooDropdownOption(value: name, label: name)];
                });
                return name;
              },
            ),
            const SizedBox(height: 16),
            AnyhooFormBuilderDropdown<String>.single(
              name: 'animal',
              label: 'Grouped + search',
              groups: _groups,
              searchEnabled: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final ok = _formKey.currentState?.saveAndValidate() ?? false;
                setState(() {
                  _saved = ok ? '${_formKey.currentState?.value}' : 'Invalid';
                });
              },
              child: const Text('Save form'),
            ),
            if (_saved.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_saved),
            ],
          ],
        ),
      ),
    );
  }
}
