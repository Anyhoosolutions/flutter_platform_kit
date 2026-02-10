import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:sentry_cli/sentry_cli.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();

  // Global options
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  parser.addFlag('version', negatable: false, help: 'Show version');

  // Connection options
  parser.addOption('token', help: 'Sentry auth token');
  parser.addOption('org', abbr: 'o', help: 'Sentry organization slug');
  parser.addOption('project', abbr: 'p', help: 'Project slug or alias');

  // Output options
  parser.addFlag('json', negatable: false, help: 'Output as JSON');

  // Filter options
  parser.addOption('query',
      abbr: 'q', help: 'Raw Sentry search query (e.g., "assigned:me")');
  parser.addOption('level',
      allowed: ['error', 'warning', 'info', 'fatal', 'debug'],
      help: 'Filter by error level');
  parser.addFlag('unresolved',
      defaultsTo: true, help: 'Only show unresolved issues (default)');
  parser.addFlag('all',
      negatable: false, help: 'Show all issues (including resolved)');
  parser.addOption('release', help: 'Filter by release (supports wildcards)');
  parser.addOption('environment',
      aliases: ['env'], help: 'Filter by environment');

  // Sort / pagination
  parser.addOption('sort',
      abbr: 's',
      defaultsTo: 'date',
      allowed: ['date', 'new', 'freq', 'priority'],
      help: 'Sort order');
  parser.addOption('limit',
      abbr: 'l', defaultsTo: '25', help: 'Max issues to return');

  // Parse
  final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    stderr.writeln();
    _printUsage(parser);
    exit(1);
  }

  if (results.flag('help')) {
    _printUsage(parser);
    return;
  }

  if (results.flag('version')) {
    print('sentry_cli 0.1.0');
    return;
  }

  // Determine command
  final command = results.rest.isNotEmpty ? results.rest.first : 'list';

  if (command == 'help') {
    _printUsage(parser);
    return;
  }

  // Load config
  final config = SentryConfig.load(
    tokenFlag: results.option('token'),
    orgFlag: results.option('org'),
    projectFlag: results.option('project'),
  );

  // Commands that only need org-level auth (no project required)
  final orgOnlyCommands = {'projects'};

  final error = orgOnlyCommands.contains(command)
      ? config.validateForOrg()
      : config.validate();
  if (error != null) {
    stderr.writeln('Error: $error');
    exit(1);
  }

  final client = SentryApiClient(config: config);

  try {
    switch (command) {
      case 'list':
        await _runList(client, results);
      case 'show':
        if (results.rest.length < 2) {
          stderr.writeln('Error: show requires an issue ID');
          stderr.writeln('Usage: sentry_cli show <issue-id>');
          exit(1);
        }
        await _runShow(client, results.rest[1], results);
      case 'projects':
        await _runProjects(client, results);
      default:
        stderr.writeln('Unknown command: $command');
        stderr.writeln('Available commands: list, show, projects');
        exit(1);
    }
  } on SentryApiException catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  } finally {
    client.close();
  }
}

Future<void> _runProjects(SentryApiClient client, ArgResults results) async {
  final projects = await client.listProjects();

  if (results.flag('json')) {
    print(const JsonEncoder.withIndent('  ')
        .convert(projects.map((p) => p.toJson()).toList()));
  } else {
    print(ProjectTableRenderer.render(projects));
    if (projects.isNotEmpty) {
      stderr.writeln(
          '\n${projects.length} project${projects.length == 1 ? '' : 's'} '
          '(org: ${client.config.org})');
    }
  }
}

Future<void> _runList(SentryApiClient client, ArgResults results) async {
  final query = SentryApiClient.buildQuery(
    rawQuery: results.option('query'),
    level: results.option('level'),
    unresolved: results.flag('unresolved'),
    all: results.flag('all'),
    release: results.option('release'),
    environment: results.option('environment'),
  );

  final sort = results.option('sort') ?? 'date';
  final limit = int.tryParse(results.option('limit') ?? '25') ?? 25;

  final issues = await client.listIssues(
    query: query,
    sort: sort,
    limit: limit,
  );

  if (results.flag('json')) {
    print(const JsonEncoder.withIndent('  ')
        .convert(issues.map((i) => i.toJson()).toList()));
  } else {
    print(TableRenderer.render(issues));
    if (issues.isNotEmpty) {
      stderr.writeln(
          '\n${issues.length} issue${issues.length == 1 ? '' : 's'} '
          '(project: ${client.config.project}, query: "$query")');
    }
  }
}

Future<void> _runShow(
    SentryApiClient client, String issueId, ArgResults results) async {
  final issue = await client.getIssue(issueId);

  if (results.flag('json')) {
    print(const JsonEncoder.withIndent('  ').convert(issue));
    return;
  }

  // Pretty-print issue details
  final metadata = issue['metadata'] as Map<String, dynamic>? ?? {};
  final stats = issue['stats'] as Map<String, dynamic>? ?? {};

  print('');
  print('  ${issue['shortId']} - ${issue['title']}');
  print('  ${'=' * 70}');
  print('');
  print('  Level:       ${issue['level']}');
  print('  Status:      ${issue['status']}');
  print('  Events:      ${issue['count']}');
  print('  Users:       ${issue['userCount']}');
  print('  First seen:  ${issue['firstSeen']}');
  print('  Last seen:   ${issue['lastSeen']}');
  print('  Culprit:     ${issue['culprit']}');

  if (metadata['type'] != null) {
    print('  Type:        ${metadata['type']}');
  }
  if (metadata['value'] != null) {
    print('  Value:       ${metadata['value']}');
  }

  print('  Link:        ${issue['permalink']}');

  // Tags
  final tags = issue['tags'] as List<dynamic>? ?? [];
  if (tags.isNotEmpty) {
    print('');
    print('  Tags:');
    for (final tag in tags) {
      final t = tag as Map<String, dynamic>;
      print('    ${t['key']}: ${t['topValues']?.map((v) => v['value']).join(', ') ?? ''}');
    }
  }

  // 24h stats
  final stats24h = stats['24h'] as List<dynamic>?;
  if (stats24h != null && stats24h.isNotEmpty) {
    final total =
        stats24h.fold<int>(0, (sum, bucket) => sum + ((bucket as List)[1] as int));
    print('');
    print('  Events (24h): $total');
  }

  print('');

  // Try to get latest event for stacktrace
  try {
    final event = await client.getLatestEvent(issueId);
    _printStacktrace(event);
  } catch (_) {
    // Stacktrace fetch failed, that's ok
  }
}

void _printStacktrace(Map<String, dynamic> event) {
  final entries = event['entries'] as List<dynamic>? ?? [];

  for (final entry in entries) {
    final entryMap = entry as Map<String, dynamic>;
    if (entryMap['type'] != 'exception') continue;

    final data = entryMap['data'] as Map<String, dynamic>? ?? {};
    final values = data['values'] as List<dynamic>? ?? [];

    for (final exc in values) {
      final excMap = exc as Map<String, dynamic>;
      print('  Exception: ${excMap['type']}: ${excMap['value']}');
      print('');

      final stacktrace =
          excMap['stacktrace'] as Map<String, dynamic>? ?? {};
      final frames = stacktrace['frames'] as List<dynamic>? ?? [];

      if (frames.isEmpty) continue;

      print('  Stacktrace (most recent last):');

      // Show frames in reverse (most recent last, like Python)
      for (final frame in frames) {
        final f = frame as Map<String, dynamic>;
        final file = f['filename'] ?? f['absPath'] ?? '?';
        final lineNo = f['lineNo'] ?? '?';
        final colNo = f['colNo'];
        final function_ = f['function'] ?? '?';
        final inApp = f['inApp'] == true;

        final marker = inApp ? '>' : ' ';
        final location =
            colNo != null ? '$file:$lineNo:$colNo' : '$file:$lineNo';
        print('  $marker $location in $function_');

        // Show context lines if available
        final context = f['context'] as List<dynamic>?;
        if (context != null && inApp) {
          for (final line in context) {
            final lineList = line as List<dynamic>;
            final num = lineList[0];
            final code = lineList[1];
            final isTarget = num == lineNo;
            final prefix = isTarget ? '>>>' : '   ';
            print('       $prefix $num | $code');
          }
        }
      }
      print('');
    }
  }
}

void _printUsage(ArgParser parser) {
  stderr.writeln('Usage: sentry_cli [options] <command> [args]');
  stderr.writeln('');
  stderr.writeln('Commands:');
  stderr.writeln('  list              List issues (default)');
  stderr.writeln('  show <issue-id>   Show issue details and stacktrace');
  stderr.writeln('  projects          List all projects in the organization');
  stderr.writeln('');
  stderr.writeln('Options:');
  stderr.writeln(parser.usage);
  stderr.writeln('');
  stderr.writeln('Examples:');
  stderr.writeln('  sentry_cli list');
  stderr.writeln('  sentry_cli list --level error --sort freq');
  stderr.writeln('  sentry_cli list -p sns --json');
  stderr.writeln('  sentry_cli list --release "com.example.*@1.2.*"');
  stderr.writeln('  sentry_cli list --query "assigned:me"');
  stderr.writeln('  sentry_cli show PROJ-123');
  stderr.writeln('  sentry_cli projects');
  stderr.writeln('');
  stderr.writeln('Config (~/.sentryrc):');
  stderr.writeln('  {');
  stderr.writeln('    "token": "sntrys_xxx...",');
  stderr.writeln('    "org": "my-org",');
  stderr.writeln('    "default_project": "my-project",');
  stderr.writeln('    "projects": {');
  stderr.writeln('      "sns": "snap-and-savor",');
  stderr.writeln('      "admin": "admin-dashboard"');
  stderr.writeln('    }');
  stderr.writeln('  }');
}
