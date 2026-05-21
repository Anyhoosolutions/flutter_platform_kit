import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_section.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_style.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_value_display.dart';
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
    this.valueDisplay = AnyhooMultiSelectValueDisplay.chips,
    this.valueSeparator = ', ',
    this.commaSeparatedMaxLines = 2,
    this.maxWidth = 280,
    this.maxVisibleOptions = 5,
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
  final AnyhooMultiSelectValueDisplay valueDisplay;
  final String valueSeparator;
  final int commaSeparatedMaxLines;

  /// Max width when the parent does not provide a finite constraint (e.g. in a [Row]).
  final double maxWidth;

  /// Max option rows shown before the list scrolls.
  final int maxVisibleOptions;

  @override
  State<AnyhooMultiSelect<T>> createState() => _AnyhooMultiSelectState<T>();
}

class _AnyhooMultiSelectState<T> extends State<AnyhooMultiSelect<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final GlobalKey _triggerKey = GlobalKey();
  final Object _tapRegionGroup = Object();

  late List<T> _selected;
  final List<T> _customItems = [];
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
    if (_overlayController.isShowing) {
      _closeOverlay();
    } else {
      _overlayController.show();
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureTrigger());
    }
  }

  void _closeOverlay() {
    if (!_overlayController.isShowing) return;
    _overlayController.hide();
    _searchController.clear();
  }

  void _updateSelection(List<T> next) {
    setState(() => _selected = next);
    print('updateSelection: $next');
    widget.onChanged(List<T>.from(next));
  }

  void _toggleItem(T item, bool? checked) {
    print('toggleItem: $item, $checked');
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
        if (section.title.toLowerCase().contains(q))
          section
        else
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

  /// Selected values in catalog order (flat [items] or [sections], then any extras).
  List<T> _selectedInItemOrder() {
    final ordered = <T>[];
    if (_isFlat) {
      for (final item in _allFlatItems) {
        if (_selected.contains(item)) ordered.add(item);
      }
    } else {
      for (final section in widget.sections!) {
        for (final item in section.items) {
          if (_selected.contains(item)) ordered.add(item);
        }
      }
    }
    for (final item in _selected) {
      if (!ordered.contains(item)) ordered.add(item);
    }
    return ordered;
  }

  Widget _buildSelectedDisplay(AnyhooMultiSelectStyle style) {
    if (_selected.isEmpty) {
      return Text(widget.emptySelectionHint, style: style.emptySelectionTextStyle);
    }

    if (widget.valueDisplay == AnyhooMultiSelectValueDisplay.commaSeparated) {
      return Text(
        _selectedInItemOrder().map(widget.labelBuilder).join(widget.valueSeparator),
        style: style.selectedTextStyle,
        maxLines: widget.commaSeparatedMaxLines,
        overflow: TextOverflow.ellipsis,
      );
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

    return Wrap(spacing: 8, runSpacing: 4, children: chips);
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
      onChanged: (checked) {
        print('checked: $checked');
        _toggleItem(item, checked);
      },
    );
  }

  Widget _buildOptionsList(List<Widget> children, {required double maxHeight}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      ),
    );
  }

  int _visibleOptionRowCount() {
    if (_isFlat) {
      final filtered = _filteredFlatItems();
      return filtered.length + (_canShowAddRow(filtered) ? 1 : 0);
    }

    final sections = _filteredSections();
    if (sections.isEmpty && _searchQuery().isNotEmpty) {
      return 1;
    }
    return sections.fold<int>(0, (count, section) => count + 1 + section.items.length);
  }

  double _optionsListMaxHeight(AnyhooMultiSelectStyle style) {
    final rowCount = _visibleOptionRowCount();
    if (rowCount == 0) {
      return 0;
    }
    final visibleRows = rowCount.clamp(1, widget.maxVisibleOptions);
    return (visibleRows * kMinInteractiveDimension).clamp(0, style.overlayMaxHeight);
  }

  Widget _buildFlatList(AnyhooMultiSelectStyle style, {required double maxHeight}) {
    final filtered = _filteredFlatItems();
    final showAdd = _canShowAddRow(filtered);
    final children = <Widget>[
      for (var i = 0; i < filtered.length; i++) _buildCheckboxRow(filtered[i], style),
      if (showAdd)
        ListTile(
          title: Text('Add "${_searchController.text.trim()}"', style: style.itemTextStyle),
          onTap: () => _addNewItem(_searchController.text.trim()),
        ),
    ];
    return _buildOptionsList(children, maxHeight: maxHeight);
  }

  Widget _buildSectionedList(AnyhooMultiSelectStyle style, {required double maxHeight}) {
    final sections = _filteredSections();
    if (sections.isEmpty && _searchQuery().isNotEmpty) {
      return _buildOptionsList([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text('No matches', style: style.itemTextStyle),
        ),
      ], maxHeight: maxHeight);
    }
    return _buildOptionsList([
      for (final section in sections) ...[
        Container(
          alignment: Alignment.centerLeft,
          color: style.sectionHeaderBackgroundColor,
          padding: style.sectionHeaderPadding,
          child: Text(section.title, style: style.sectionHeaderStyle),
        ),
        for (final item in section.items) _buildCheckboxRow(item, style),
      ],
    ], maxHeight: maxHeight);
  }

  Widget _buildOverlay(AnyhooMultiSelectStyle style, {required double width}) {
    final search = _buildSearchField(style);
    final listMaxHeight = _optionsListMaxHeight(style);
    final list = _isFlat
        ? _buildFlatList(style, maxHeight: listMaxHeight)
        : _buildSectionedList(style, maxHeight: listMaxHeight);

    Widget? footer;
    if (style.overlayFooter != null) {
      footer = style.overlayFooter;
    } else if (style.closeOverlayButtonLabel != null) {
      footer = Center(
        child: TextButton(onPressed: _closeOverlay, child: Text(style.closeOverlayButtonLabel!)),
      );
    }

    return SizedBox(
      width: width,
      child: Material(
        elevation: style.overlayElevation,
        color: style.overlayBackgroundColor,
        borderRadius: style.overlayBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: style.overlayPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (search != null) ...[search, const SizedBox(height: 8)],
              if (listMaxHeight > 0) list,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : widget.maxWidth;
        final overlayWidth = _triggerWidth > 0 ? _triggerWidth : fieldWidth;

        return SizedBox(
          width: fieldWidth,
          child: TapRegion(
            groupId: _tapRegionGroup,
            onTapOutside: (_) => _closeOverlay(),
            child: OverlayPortal(
              controller: _overlayController,
              overlayChildBuilder: (context) {
                return TapRegion(
                  groupId: _tapRegionGroup,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, _triggerHeight + 5),
                    child: UnconstrainedBox(
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.topLeft,
                      child: _buildOverlay(style, width: overlayWidth),
                    ),
                  ),
                );
              },
              child: CompositedTransformTarget(
                link: _layerLink,
                child: InkWell(
                  onTap: _toggleOverlay,
                  child: Semantics(
                    label: widget.semanticLabel,
                    child: InputDecorator(
                      key: _triggerKey,
                      decoration: fieldDecoration,
                      child: _buildSelectedDisplay(style),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
