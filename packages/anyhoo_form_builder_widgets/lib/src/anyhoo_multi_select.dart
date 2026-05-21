import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_section.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_style.dart';
import 'package:flutter/material.dart';

/// Multi-select field with optional search, sections, add-new (flat only), and styling.
class AnyhooMultiSelect<T> extends StatefulWidget {
  const AnyhooMultiSelect({
    super.key,
    required this.labelBuilder,
    required this.value,
    required this.onChanged,
    this.items,
    this.sections,
    this.searchEnabled = true,
    this.allowAddNew = false,
    this.style,
    this.label,
    this.semanticLabel,
    this.emptySelectionHint = 'Select items...',
    this.maxVisibleChips = 3,
    this.createItem,
  }) : assert(items != null || sections != null, 'Provide either items or sections'),
       assert(items == null || sections == null, 'Provide only one of items or sections'),
       assert(!allowAddNew || sections == null, 'allowAddNew requires flat items mode');

  /// Builds a new value when the user adds an entry (required for non-[String] [T] when [allowAddNew] is true).
  final T Function(String label)? createItem;

  final String Function(T item) labelBuilder;
  final List<T> value;
  final ValueChanged<List<T>> onChanged;

  /// Flat list mode.
  final List<T>? items;

  /// Sectioned list mode (mutually exclusive with [items]).
  final List<AnyhooMultiSelectSection<T>>? sections;

  final bool searchEnabled;
  final bool allowAddNew;
  final AnyhooMultiSelectStyle? style;
  final String? label;
  final String? semanticLabel;
  final String emptySelectionHint;
  final int maxVisibleChips;

  @override
  State<AnyhooMultiSelect<T>> createState() => _AnyhooMultiSelectState<T>();
}

class _AnyhooMultiSelectState<T> extends State<AnyhooMultiSelect<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();

  late List<T> _selected;
  final List<T> _customItems = [];
  bool _overlayVisible = false;
  double _triggerWidth = 0;
  double _triggerHeight = 0;

  bool get _isFlat => widget.items != null;

  List<T> get _allFlatItems => [...?widget.items, ..._customItems];

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.value);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant AnyhooMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_listEquals(oldWidget.value, widget.value)) {
      _selected = List<T>.from(widget.value);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _listEquals(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _onSearchChanged() => setState(() {});

  void _measureTrigger() {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    if (size.width != _triggerWidth || size.height != _triggerHeight) {
      setState(() {
        _triggerWidth = size.width;
        _triggerHeight = size.height;
      });
    }
  }

  void _toggleOverlay() {
    setState(() => _overlayVisible = !_overlayVisible);
    if (_overlayVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureTrigger());
    }
  }

  void _closeOverlay() {
    if (!_overlayVisible) return;
    setState(() {
      _overlayVisible = false;
      _searchController.clear();
    });
  }

  void _updateSelection(List<T> next) {
    setState(() => _selected = next);
    widget.onChanged(List<T>.from(next));
  }

  void _toggleItem(T item, bool? checked) {
    final next = List<T>.from(_selected);
    if (checked == true) {
      if (!next.contains(item)) next.add(item);
    } else {
      next.remove(item);
    }
    _updateSelection(next);
  }

  AnyhooMultiSelectStyle _resolvedStyle(BuildContext context) {
    return AnyhooMultiSelectStyle.fromTheme(context).merge(widget.style);
  }

  String _searchQuery() => _searchController.text.trim().toLowerCase();

  bool _matchesSearch(T item) {
    final q = _searchQuery();
    if (q.isEmpty) return true;
    return widget.labelBuilder(item).toLowerCase().contains(q);
  }

  List<T> _filteredFlatItems() {
    return _allFlatItems.where(_matchesSearch).toList();
  }

  List<AnyhooMultiSelectSection<T>> _filteredSections() {
    final sections = widget.sections!;
    final q = _searchQuery();
    if (q.isEmpty) return sections;
    return [
      for (final section in sections)
        AnyhooMultiSelectSection<T>(title: section.title, items: section.items.where(_matchesSearch).toList()),
    ].where((s) => s.items.isNotEmpty).toList();
  }

  bool _canShowAddRow(List<T> filtered) {
    if (!widget.allowAddNew || !_isFlat) return false;
    final query = _searchController.text.trim();
    if (query.isEmpty) return false;
    return !filtered.any((item) => widget.labelBuilder(item).toLowerCase() == query.toLowerCase());
  }

  void _addNewItem(String raw) {
    final label = raw.trim();
    if (label.isEmpty) return;
    final existing = _allFlatItems.where((item) => widget.labelBuilder(item).toLowerCase() == label.toLowerCase());
    final T newItem;
    if (existing.isNotEmpty) {
      newItem = existing.first;
    } else {
      final create = widget.createItem ?? _defaultCreateItem;
      newItem = create(label);
      if (!_customItems.contains(newItem)) {
        _customItems.add(newItem);
      }
    }
    final next = List<T>.from(_selected);
    if (!next.contains(newItem)) next.add(newItem);
    _searchController.clear();
    _updateSelection(next);
  }

  T _defaultCreateItem(String label) => label as T;

  List<Widget> _buildChips(AnyhooMultiSelectStyle style) {
    if (_selected.isEmpty) {
      return [Text(widget.emptySelectionHint, style: style.emptySelectionTextStyle)];
    }

    final max = widget.maxVisibleChips;
    final visible = _selected.length > max ? _selected.sublist(0, max) : _selected;
    final chips = visible.map((item) {
      return Chip(
        backgroundColor: style.chipBackgroundColor,
        label: Text(widget.labelBuilder(item), style: style.chipLabelStyle),
        deleteIconColor: style.chipDeleteIconColor,
        onDeleted: () => _toggleItem(item, false),
      );
    }).toList();

    if (_selected.length > max) {
      chips.add(Chip(label: Text('+${_selected.length - max} more')));
    }
    return chips;
  }

  Widget? _buildSearchField(AnyhooMultiSelectStyle style) {
    if (!widget.searchEnabled) return null;
    final hint = widget.allowAddNew ? 'Search or add new...' : (style.searchHintText ?? 'Search...');
    return TextField(
      controller: _searchController,
      decoration: (style.searchFieldDecoration ?? const InputDecoration(border: OutlineInputBorder())).copyWith(
        hintText: hint,
      ),
    );
  }

  Widget _buildCheckboxRow(T item, AnyhooMultiSelectStyle style) {
    return CheckboxListTile(
      title: Text(widget.labelBuilder(item), style: style.itemTextStyle),
      value: _selected.contains(item),
      activeColor: style.checkboxActiveColor,
      onChanged: (checked) => _toggleItem(item, checked),
    );
  }

  Widget _buildFlatList(AnyhooMultiSelectStyle style) {
    final filtered = _filteredFlatItems();
    final showAdd = _canShowAddRow(filtered);
    final count = filtered.length + (showAdd ? 1 : 0);

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: count,
      itemBuilder: (context, index) {
        if (showAdd && index == filtered.length) {
          final query = _searchController.text.trim();
          return ListTile(
            title: Text('Add "$query"', style: style.itemTextStyle),
            onTap: () => _addNewItem(query),
          );
        }
        return _buildCheckboxRow(filtered[index], style);
      },
    );
  }

  Widget _buildSectionedList(AnyhooMultiSelectStyle style) {
    final sections = _filteredSections();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        for (final section in sections) ...[
          Container(
            width: double.infinity,
            color: style.sectionHeaderBackgroundColor,
            padding: style.sectionHeaderPadding,
            child: Text(section.title, style: style.sectionHeaderStyle),
          ),
          for (final item in section.items) _buildCheckboxRow(item, style),
        ],
      ],
    );
  }

  Widget _buildOverlay(AnyhooMultiSelectStyle style) {
    final search = _buildSearchField(style);
    final list = _isFlat ? _buildFlatList(style) : _buildSectionedList(style);

    Widget? footer;
    if (style.overlayFooter != null) {
      footer = style.overlayFooter;
    } else if (style.closeOverlayButtonLabel != null) {
      footer = Center(
        child: TextButton(onPressed: _closeOverlay, child: Text(style.closeOverlayButtonLabel!)),
      );
    }

    return Material(
      elevation: style.overlayElevation,
      color: style.overlayBackgroundColor,
      borderRadius: style.overlayBorderRadius,
      child: SizedBox(
        width: _triggerWidth > 0 ? _triggerWidth : null,
        child: Padding(
          padding: style.overlayPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (search != null) ...[search, const SizedBox(height: 8)],
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: style.overlayMaxHeight),
                child: ClipRRect(
                  borderRadius: style.overlayBorderRadius ?? BorderRadius.zero,
                  child: list,
                ),
              ),
              if (footer != null) ...[const SizedBox(height: 8), footer],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTrigger());

    final style = _resolvedStyle(context);
    final fieldDecoration = (style.fieldDecoration ?? const InputDecoration(border: OutlineInputBorder())).copyWith(
      labelText: widget.label,
    );

    return TapRegion(
      onTapOutside: (_) => _closeOverlay(),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _toggleOverlay,
              child: Semantics(
                label: widget.semanticLabel,
                child: InputDecorator(
                  key: _triggerKey,
                  decoration: fieldDecoration,
                  child: Wrap(spacing: 8, runSpacing: 4, children: _buildChips(style)),
                ),
              ),
            ),
            if (_overlayVisible)
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, _triggerHeight + 5),
                child: _buildOverlay(style),
              ),
          ],
        ),
      ),
    );
  }
}
