import 'dart:math';

import 'sentry_api.dart';

/// Renders a list of Sentry projects as an ASCII table.
class ProjectTableRenderer {
  static String render(List<SentryProject> projects) {
    if (projects.isEmpty) {
      return 'No projects found.';
    }

    final columns = <_GenericColumn<SentryProject>>[
      _GenericColumn('Slug', (p) => p.slug),
      _GenericColumn('Name', (p) => p.name),
      _GenericColumn('Platform', (p) => p.platform ?? '-'),
      _GenericColumn('Status', (p) => p.status),
    ];

    // Calculate column widths
    for (final col in columns) {
      col.width = col.header.length;
      for (final project in projects) {
        col.width = max(col.width, col.extract(project).length);
      }
    }

    final buf = StringBuffer();

    // Header
    buf.writeln(_renderRow(columns, (col) => col.header));

    // Separator
    buf.writeln(columns.map((c) => '-' * (c.width + 2)).join('+'));

    // Rows
    for (final project in projects) {
      buf.writeln(_renderRow(columns, (col) => col.extract(project)));
    }

    return buf.toString();
  }

  static String _renderRow(
    List<_GenericColumn<SentryProject>> columns,
    String Function(_GenericColumn<SentryProject>) getValue,
  ) {
    return columns.map((col) {
      final value = getValue(col);
      if (col.rightAlign) {
        return ' ${value.padLeft(col.width)} ';
      }
      return ' ${value.padRight(col.width)} ';
    }).join('|');
  }
}

class _GenericColumn<T> {
  final String header;
  final String Function(T) extract;
  final bool rightAlign;
  int width;

  _GenericColumn(this.header, this.extract, {this.rightAlign = false})
      : width = header.length;
}

/// Renders a list of Sentry issues as an ASCII table.
class TableRenderer {
  /// Render issues as an ASCII table to stdout.
  static String render(List<SentryIssue> issues) {
    if (issues.isEmpty) {
      return 'No issues found.';
    }

    // Define columns
    final columns = <_Column>[
      _Column('ID', (i) => i.shortId),
      _Column('Lvl', (i) => _shortLevel(i.level)),
      _Column('Events', (i) => _formatCount(i.count), rightAlign: true),
      _Column('Users', (i) => _formatCount(i.userCount), rightAlign: true),
      _Column('First Seen', (i) => _formatDate(i.firstSeen)),
      _Column('Last Seen', (i) => _formatDate(i.lastSeen)),
      _Column('Title', (i) => _truncate(i.title, 60)),
    ];

    // Calculate column widths
    for (final col in columns) {
      col.width = col.header.length;
      for (final issue in issues) {
        col.width = max(col.width, col.extract(issue).length);
      }
    }

    final buf = StringBuffer();

    // Header
    buf.writeln(_renderRow(columns, (col) => col.header));

    // Separator
    buf.writeln(columns.map((c) => '-' * (c.width + 2)).join('+'));

    // Rows
    for (final issue in issues) {
      buf.writeln(_renderRow(columns, (col) => col.extract(issue)));
    }

    return buf.toString();
  }

  static String _renderRow(
    List<_Column> columns,
    String Function(_Column) getValue,
  ) {
    return columns.map((col) {
      final value = getValue(col);
      if (col.rightAlign) {
        return ' ${value.padLeft(col.width)} ';
      }
      return ' ${value.padRight(col.width)} ';
    }).join('|');
  }

  static String _shortLevel(String level) {
    switch (level) {
      case 'error':
        return 'ERR';
      case 'warning':
        return 'WRN';
      case 'info':
        return 'INF';
      case 'fatal':
        return 'FTL';
      case 'debug':
        return 'DBG';
      default:
        return level.substring(0, min(3, level.length)).toUpperCase();
    }
  }

  static String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  static String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String _truncate(String s, int maxLen) {
    if (s.length <= maxLen) return s;
    return '${s.substring(0, maxLen - 3)}...';
  }
}

class _Column {
  final String header;
  final String Function(SentryIssue) extract;
  final bool rightAlign;
  int width;

  _Column(this.header, this.extract, {this.rightAlign = false})
      : width = header.length;
}
