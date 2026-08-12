import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Read-only date field that opens a picker via [onTap].
class AnyhooDateField extends StatelessWidget {
  const AnyhooDateField({
    super.key,
    required this.date,
    required this.onTap,
    this.hint = 'Select date',
    this.formatDate,
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String hint;

  /// Optional custom formatter; defaults to `MMM d, yyyy`.
  final String Function(DateTime date)? formatDate;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface.containerLow,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(color: surface.cardBorder.withValues(alpha: 0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingMd,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: accent.primaryFixed),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Text(
                    date != null
                        ? (formatDate ?? _defaultFormatDate)(date!)
                        : hint,
                    style: AnyhooTypography.body(BodySize.large).copyWith(
                      color: date != null
                          ? surface.primaryText
                          : surface.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Self-contained month calendar grid with navigation and day selection.
class AnyhooCalendar extends StatefulWidget {
  const AnyhooCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.initialMonth,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? initialMonth;

  @override
  State<AnyhooCalendar> createState() => _AnyhooCalendarState();
}

class _AnyhooCalendarState extends State<AnyhooCalendar> {
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final seed = widget.initialMonth ?? widget.selectedDate ?? DateTime.now();
    _visibleMonth = DateTime(seed.year, seed.month);
  }

  void _prevMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final monthLabel =
        '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}';
    final days = _daysInMonthGrid(_visibleMonth);

    return AnyhooCardShell(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: Icon(Icons.chevron_left, color: surface.secondaryText),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: AnyhooTypography.label(LabelSize.large).copyWith(
                    color: surface.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: Icon(Icons.chevron_right, color: surface.secondaryText),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            children: [
              for (final label in _weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AnyhooTypography.label(LabelSize.medium).copyWith(
                        color: surface.secondaryText,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          for (var week = 0; week < days.length; week += 7)
            Row(
              children: [
                for (var d = 0; d < 7; d++)
                  Expanded(
                    child: _DayCell(
                      date: days[week + d],
                      selectedDate: widget.selectedDate,
                      primary: accent.primaryFixed,
                      onPrimary: accent.onPrimaryFixed,
                      onSurface: surface.primaryText,
                      onTap: widget.onDateSelected,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  /// Returns a flat Sunday-start grid of dates covering [month].
  List<DateTime?> _daysInMonthGrid(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // weekday: Mon=1 … Sun=7 → Sunday-start offset
    final leading = first.weekday % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selectedDate,
    required this.primary,
    required this.onPrimary,
    required this.onSurface,
    required this.onTap,
  });

  final DateTime? date;
  final DateTime? selectedDate;
  final Color primary;
  final Color onPrimary;
  final Color onSurface;
  final ValueChanged<DateTime>? onTap;

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const SizedBox(height: 40);
    }

    final selected = selectedDate != null &&
        date!.year == selectedDate!.year &&
        date!.month == selectedDate!.month &&
        date!.day == selectedDate!.day;

    return SizedBox(
      height: 40,
      child: Center(
        child: Material(
          color: selected ? primary : Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap == null ? null : () => onTap!(date!),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Text(
                  '${date!.day}',
                  style: AnyhooTypography.label(LabelSize.medium).copyWith(
                    color: selected ? onPrimary : onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _defaultFormatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
