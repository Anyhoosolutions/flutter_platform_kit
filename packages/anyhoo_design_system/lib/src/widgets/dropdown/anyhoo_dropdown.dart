import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Outlined dropdown field with overlay options.
///
/// Use [AnyhooDropdown.single] or [AnyhooDropdown.multi]. Pass [onCreate] to
/// show an add-new footer (single closes after create; multi stays open).
class AnyhooDropdown<T> extends StatefulWidget {
  const AnyhooDropdown.single({
    super.key,
    required this.options,
    required T? value,
    required ValueChanged<T?> onChanged,
    this.label,
    this.hint = 'Select...',
    this.onCreate,
    this.semanticLabel,
    this.maxWidth = 280,
    this.maxVisibleOptions = 6,
  }) : isMulti = false,
       singleValue = value,
       onSingleChanged = onChanged,
       multiValue = const [],
       onMultiChanged = null;

  const AnyhooDropdown.multi({
    super.key,
    required this.options,
    required List<T> value,
    required ValueChanged<List<T>> onChanged,
    this.label,
    this.hint = 'Select items...',
    this.onCreate,
    this.semanticLabel,
    this.maxWidth = 280,
    this.maxVisibleOptions = 6,
  }) : isMulti = true,
       multiValue = value,
       onMultiChanged = onChanged,
       singleValue = null,
       onSingleChanged = null;

  final bool isMulti;
  final List<AnyhooDropdownOption<T>> options;
  final T? singleValue;
  final ValueChanged<T?>? onSingleChanged;
  final List<T> multiValue;
  final ValueChanged<List<T>>? onMultiChanged;
  final String? label;
  final String hint;
  final T Function(String label)? onCreate;
  final String? semanticLabel;
  final double maxWidth;
  final int maxVisibleOptions;

  static const int maxVisibleChips = 3;

  @override
  State<AnyhooDropdown<T>> createState() => _AnyhooDropdownState<T>();
}

class _AnyhooDropdownState<T> extends State<AnyhooDropdown<T>> {
  static const _overlayGap = 8.0;
  static const _overlayEdgePadding = 16.0;
  static const _rowHeight = 48.0;
  static const _footerHeight = 56.0;
  static const _overlayPadding = 8.0;

  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  final TextEditingController _addController = TextEditingController();
  final Object _tapRegionGroup = Object();

  bool _openAbove = false;
  double _overlayMaxHeight = 240;
  double _triggerWidth = 0;

  bool get _isOpen => _overlayController.isShowing;

  @override
  void initState() {
    super.initState();
    _addController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  String _labelFor(T value) {
    for (final option in widget.options) {
      if (option.value == value) return option.label;
    }
    return value.toString();
  }

  bool _isSelected(T value) {
    if (widget.isMulti) return widget.multiValue.contains(value);
    return widget.singleValue == value;
  }

  void _closeOverlay() {
    if (!_isOpen) return;
    _addController.clear();
    _overlayController.hide();
    setState(() {});
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _closeOverlay();
      return;
    }
    _measureAndOpen();
  }

  void _measureAndOpen() {
    final overlayState = Overlay.of(context);
    final triggerBox = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox = overlayState.context.findRenderObject() as RenderBox?;

    var openAbove = false;
    var maxHeight = 240.0;
    var width = _triggerWidth;

    if (triggerBox != null && overlayBox != null) {
      final triggerOffset = triggerBox.localToGlobal(Offset.zero, ancestor: overlayBox);
      final triggerSize = triggerBox.size;
      width = triggerSize.width;
      final overlaySize = overlayBox.size;
      final estimated = _estimatedOverlayHeight();
      final below = overlaySize.height - (triggerOffset.dy + triggerSize.height) - _overlayEdgePadding;
      final above = triggerOffset.dy - _overlayEdgePadding;
      openAbove = estimated > below && above > below;
      final available = (openAbove ? above : below) - _overlayGap;
      maxHeight = available.clamp(kMinInteractiveDimension, 480);
    }

    setState(() {
      _openAbove = openAbove;
      _overlayMaxHeight = maxHeight;
      _triggerWidth = width;
    });
    _overlayController.show();
  }

  double _estimatedOverlayHeight() {
    final rows = widget.options.length.clamp(1, widget.maxVisibleOptions);
    final listHeight = rows * _rowHeight;
    final footer = widget.onCreate != null ? _footerHeight : 0.0;
    return listHeight + footer + _overlayPadding * 2;
  }

  void _onOptionTap(AnyhooDropdownOption<T> option) {
    if (widget.isMulti) {
      final next = List<T>.of(widget.multiValue);
      if (next.contains(option.value)) {
        next.remove(option.value);
      } else {
        next.add(option.value);
      }
      widget.onMultiChanged!(next);
      return;
    }
    widget.onSingleChanged!(option.value);
    _closeOverlay();
  }

  void _removeMulti(T value) {
    final next = List<T>.of(widget.multiValue)..remove(value);
    widget.onMultiChanged!(next);
  }

  void _submitCreate() {
    final name = _addController.text.trim();
    if (name.isEmpty || widget.onCreate == null) return;
    final created = widget.onCreate!(name);
    _addController.clear();
    if (widget.isMulti) {
      if (!widget.multiValue.contains(created)) {
        widget.onMultiChanged!([...widget.multiValue, created]);
      }
      return;
    }
    widget.onSingleChanged!(created);
    _closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : widget.maxWidth;
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
                    targetAnchor: _openAbove ? Alignment.topLeft : Alignment.bottomLeft,
                    followerAnchor: _openAbove ? Alignment.bottomLeft : Alignment.topLeft,
                    offset: Offset(0, _openAbove ? -_overlayGap : _overlayGap),
                    child: UnconstrainedBox(
                      clipBehavior: Clip.hardEdge,
                      alignment: _openAbove ? Alignment.bottomLeft : Alignment.topLeft,
                      child: _DropdownOverlay<T>(
                        width: _triggerWidth > 0 ? _triggerWidth : fieldWidth,
                        maxListHeight: _overlayMaxHeight,
                        options: widget.options,
                        isSelected: _isSelected,
                        onOptionTap: _onOptionTap,
                        onCreate: widget.onCreate,
                        addController: _addController,
                        onSubmitCreate: _submitCreate,
                      ),
                    ),
                  ),
                );
              },
              child: CompositedTransformTarget(
                link: _layerLink,
                child: _DropdownField<T>(
                  triggerKey: _triggerKey,
                  label: widget.label,
                  semanticLabel: widget.semanticLabel,
                  hint: widget.hint,
                  isOpen: _isOpen,
                  isMulti: widget.isMulti,
                  singleValue: widget.singleValue,
                  multiValue: widget.multiValue,
                  labelFor: _labelFor,
                  onToggle: _toggleOverlay,
                  onRemoveMulti: _removeMulti,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.triggerKey,
    required this.label,
    required this.semanticLabel,
    required this.hint,
    required this.isOpen,
    required this.isMulti,
    required this.singleValue,
    required this.multiValue,
    required this.labelFor,
    required this.onToggle,
    required this.onRemoveMulti,
  });

  final Key triggerKey;
  final String? label;
  final String? semanticLabel;
  final String hint;
  final bool isOpen;
  final bool isMulti;
  final T? singleValue;
  final List<T> multiValue;
  final String Function(T value) labelFor;
  final VoidCallback onToggle;
  final ValueChanged<T> onRemoveMulti;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AnyhooTypography.label(LabelSize.medium).copyWith(color: surface.secondaryText),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
        ],
        Semantics(
          label: semanticLabel ?? label,
          button: true,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              child: DecoratedBox(
                key: triggerKey,
                decoration: BoxDecoration(
                  color: surface.containerLowest,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(color: surface.outline.withValues(alpha: 0.6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd,
                    vertical: DesignTokens.spacingSm,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _valueChild(context)),
                      Icon(
                        isOpen ? Icons.expand_less : Icons.expand_more,
                        color: surface.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _valueChild(BuildContext context) {
    final surface = context.surface;
    if (!isMulti) {
      if (singleValue == null) {
        return Text(
          hint,
          style: AnyhooTypography.body(BodySize.large).copyWith(color: surface.secondaryText),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
      return Text(
        labelFor(singleValue as T),
        style: AnyhooTypography.body(BodySize.large).copyWith(color: surface.primaryText),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (multiValue.isEmpty) {
      return Text(
        hint,
        style: AnyhooTypography.body(BodySize.large).copyWith(color: surface.secondaryText),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return _MultiValueChips<T>(
      values: multiValue,
      labelFor: labelFor,
      onRemove: onRemoveMulti,
    );
  }
}

class _MultiValueChips<T> extends StatelessWidget {
  const _MultiValueChips({
    required this.values,
    required this.labelFor,
    required this.onRemove,
  });

  final List<T> values;
  final String Function(T value) labelFor;
  final ValueChanged<T> onRemove;

  @override
  Widget build(BuildContext context) {
    final overflow = values.length > AnyhooDropdown.maxVisibleChips;
    final visibleCount = overflow ? AnyhooDropdown.maxVisibleChips - 1 : values.length;
    final visible = values.take(visibleCount).toList();
    final hiddenCount = values.length - visibleCount;

    return Wrap(
      spacing: DesignTokens.spacingXs,
      runSpacing: DesignTokens.spacingXs,
      children: [
        for (final value in visible)
          GestureDetector(
            onTap: () {},
            child: AnyhooChip(
              label: labelFor(value),
              onDeleted: () => onRemove(value),
            ),
          ),
        if (overflow)
          AnyhooChip(
            label: '+$hiddenCount items',
            variant: AnyhooChipVariant.neutral,
          ),
      ],
    );
  }
}

class _DropdownOverlay<T> extends StatelessWidget {
  const _DropdownOverlay({
    required this.width,
    required this.maxListHeight,
    required this.options,
    required this.isSelected,
    required this.onOptionTap,
    required this.onCreate,
    required this.addController,
    required this.onSubmitCreate,
  });

  final double width;
  final double maxListHeight;
  final List<AnyhooDropdownOption<T>> options;
  final bool Function(T value) isSelected;
  final ValueChanged<AnyhooDropdownOption<T>> onOptionTap;
  final T Function(String label)? onCreate;
  final TextEditingController addController;
  final VoidCallback onSubmitCreate;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final footerHeight = onCreate != null ? _AnyhooDropdownState._footerHeight : 0.0;
    final listMax = (maxListHeight - footerHeight - _AnyhooDropdownState._overlayPadding * 2)
        .clamp(0, maxListHeight)
        .toDouble();

    return Material(
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      color: surface.cardBackground,
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(_AnyhooDropdownState._overlayPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (options.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: listMax),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final selected = isSelected(option.value);
                      return InkWell(
                        onTap: () => onOptionTap(option),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        child: ColoredBox(
                          color: selected
                              ? accent.primaryFixed.withValues(alpha: 0.12)
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingMd,
                              vertical: DesignTokens.spacingSm,
                            ),
                            child: SizedBox(
                              height: 32,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: AnyhooTypography.body(BodySize.large).copyWith(
                                        color: surface.primaryText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (selected)
                                    Icon(Icons.check, size: 20, color: accent.primaryFixed),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (onCreate != null) ...[
                const SizedBox(height: DesignTokens.spacingSm),
                _AddNewFooter(
                  controller: addController,
                  onSubmit: onSubmitCreate,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddNewFooter extends StatelessWidget {
  const _AddNewFooter({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final canSubmit = controller.text.trim().isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(color: surface.outline.withValues(alpha: 0.6)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm),
              child: TextField(
                controller: controller,
                style: AnyhooTypography.body(BodySize.medium).copyWith(color: surface.primaryText),
                decoration: InputDecoration(
                  hintText: 'New option name...',
                  hintStyle: AnyhooTypography.body(BodySize.medium).copyWith(
                    color: surface.secondaryText,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingSm),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSubmit(),
                inputFormatters: [LengthLimitingTextInputFormatter(80)],
              ),
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        Material(
          color: canSubmit ? accent.primaryFixed : surface.containerHigh,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: InkWell(
            onTap: canSubmit ? onSubmit : null,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.add,
                color: canSubmit ? accent.onPrimaryFixed : surface.secondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
