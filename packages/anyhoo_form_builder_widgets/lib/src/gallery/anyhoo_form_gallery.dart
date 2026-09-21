import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AnyhooFormGallery extends StatefulWidget {
  const AnyhooFormGallery({super.key});

  @override
  State<AnyhooFormGallery> createState() => _AnyhooFormGalleryState();
}

class _AnyhooFormGalleryState extends State<AnyhooFormGallery> {
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
            ..._dropdowns(),
            ..._divider(),
            ...filterChips(),
            ..._divider(),
            ...checkboxes(),
            ..._divider(),
            ...radioGroup(),
            ..._divider(),
            ...switches(),
            ..._divider(),
            ...segmentedControls(),
            ..._divider(),
            ...sliders(),
            ..._divider(),
            ...datePickers(),
            ..._divider(),
            ...textFields(),
            ..._divider(),

            ElevatedButton(
              onPressed: () {
                final ok = _formKey.currentState?.saveAndValidate() ?? false;
                setState(() {
                  _saved = ok ? '${_formKey.currentState?.value}' : 'Invalid';
                });
              },
              child: const Text('Save form'),
            ),
            const SizedBox(height: 16),
            if (_saved.isNotEmpty) ...[const SizedBox(height: 8), Text(_saved)],
          ],
        ),
      ),
    );
  }

  List<Widget> _dropdowns() {
    return [
      const Text(
        'AnyhooFormBuilderDropdown wraps AnyhooDropdown in FormBuilderField. '
        'Use .single (T) or .multi (List<T>). Same options/groups/searchEnabled/onCreate '
        'as the design-system widget. name, initialValue, and validator are the form arguments.',
      ),
      const SizedBox(height: 16),
      AnyhooFormDropdown<String>.single(
        name: 'widgetType',
        label: 'Single (elevated)',
        options: _types,
        initialValue: 'elevated',
        validator: (value) => value == null ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      AnyhooFormDropdown<String>.multi(
        name: 'tags',
        label: 'Multi + onCreate (tags)',
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
      AnyhooFormDropdown<String>.single(
        name: 'animal',
        label: 'Grouped + search (animal)',
        groups: _groups,
        searchEnabled: true,
      ),
    ];
  }

  List<Widget> filterChips() {
    return [
      const Text('Filter chips that can be selected and deselected.').pad(b: 16),
      Row(
        spacing: 8,
        children: [
          AnyhooFormFilterChip(name: 'design', label: 'Design'),
          AnyhooFormFilterChip(name: 'dev', label: 'Dev'),
        ],
      ),
    ];
  }

  List<Widget> checkboxes() {
    return [
      const Text('Checkboxes that can be selected and deselected.').pad(b: 16),
      AnyhooFormCheckbox(name: 'fun', label: 'Fun'),
      AnyhooFormCheckbox(name: 'boring', label: 'Boring'),
    ];
  }

  List<Widget> radioGroup() {
    return [
      const Text('Checkboxes that can be selected and deselected.').pad(b: 16),
      AnyhooFormRadioGroup(
        name: 'size',
        options: [('small', 'Small'), ('medium', 'Medium'), ('large', 'Large'), ('xl', 'XL'), ('xxl', 'XXL')],
      ),
    ];
  }

  List<Widget> switches() {
    return [
      const Text('Switches').pad(b: 16),
      AnyhooFormSwitch(name: 'include', label: 'Include'),
      AnyhooFormSwitch(name: 'favorite', label: 'Favorite'),
    ];
  }

  List<Widget> segmentedControls() {
    return [
      const Text('Segmented controls').pad(b: 16),
      AnyhooFormSegmentControl<String>(
        name: 'cost',
        segments: [
          AnyhooSegment(value: 'cheap', label: 'Cheap'),
          AnyhooSegment(value: 'medium', label: 'Medium'),
          AnyhooSegment(value: 'expensive', label: 'Expensive'),
        ],
      ),
    ];
  }

  List<Widget> sliders() {
    return [
      const Text('AnyhooFormSlider').pad(b: 16),
      AnyhooFormSlider(name: 'distance', min: 3, max: 20, divisions: 7),
    ];
  }

  List<Widget> datePickers() {
    return [
      'Date Pickers'.headline().pad(b: 16),
      'Date Pickers'.headline(size: HeadlineSize.small).pad(b: 8),
      AnyhooFormDatePicker(name: 'date'),
      'Calendar'.headline(size: HeadlineSize.small).pad(t: 8, b: 8),
      AnyhooFormCalendar(name: 'caldate'),
    ];
  }

  List<Widget> textFields() {
    return [const Text('AnyhooFormTextField').pad(b: 16), AnyhooFormTextField(name: 'search', hint: 'Search')];
  }

  List<Widget> _divider() {
    return [SizedBox(height: 16), Divider(), const SizedBox(height: 16)];
  }
}
