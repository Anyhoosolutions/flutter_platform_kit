import 'dart:convert';
import 'dart:io';

/// Configuration loaded from ~/.sentryrc, environment, and CLI flags.
class SentryConfig {
  final String token;
  final String org;
  final String project;
  final Map<String, String> projectAliases;

  SentryConfig({
    required this.token,
    required this.org,
    required this.project,
    this.projectAliases = const {},
  });

  /// Load config by merging (in priority order):
  /// 1. CLI flags (highest)
  /// 2. Environment variables
  /// 3. ~/.sentryrc file (lowest)
  static SentryConfig load({
    String? tokenFlag,
    String? orgFlag,
    String? projectFlag,
  }) {
    final rcConfig = _loadRcFile();

    // Token: flag > env > rc
    final token = tokenFlag ??
        Platform.environment['SENTRY_AUTH_TOKEN'] ??
        rcConfig['token'] as String? ??
        '';

    // Org: flag > env > rc
    final org = orgFlag ??
        Platform.environment['SENTRY_ORG'] ??
        rcConfig['org'] as String? ??
        '';

    // Project aliases from rc
    final aliasesRaw = rcConfig['projects'] as Map<String, dynamic>? ?? {};
    final aliases =
        aliasesRaw.map((key, value) => MapEntry(key, value.toString()));

    // Project: flag (resolve alias) > env > rc default
    final defaultProject = rcConfig['default_project'] as String? ?? '';
    String project;
    if (projectFlag != null) {
      project = aliases[projectFlag] ?? projectFlag;
    } else {
      project =
          Platform.environment['SENTRY_PROJECT'] ?? defaultProject;
    }

    return SentryConfig(
      token: token,
      org: org,
      project: project,
      projectAliases: aliases,
    );
  }

  /// Validate that required fields are present.
  String? validate() {
    final orgError = validateForOrg();
    if (orgError != null) return orgError;
    if (project.isEmpty) {
      return 'No Sentry project. Set via --project, SENTRY_PROJECT env var, or ~/.sentryrc';
    }
    return null;
  }

  /// Validate only token + org (project not required).
  String? validateForOrg() {
    if (token.isEmpty) {
      return 'No Sentry auth token. Set via --token, SENTRY_AUTH_TOKEN env var, or ~/.sentryrc';
    }
    if (org.isEmpty) {
      return 'No Sentry organization. Set via --org, SENTRY_ORG env var, or ~/.sentryrc';
    }
    return null;
  }

  static Map<String, dynamic> _loadRcFile() {
    final home = Platform.environment['HOME'] ?? '';
    if (home.isEmpty) return {};

    final rcFile = File('$home/.sentryrc');
    if (!rcFile.existsSync()) return {};

    try {
      final content = rcFile.readAsStringSync();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      stderr.writeln('Warning: Failed to parse ~/.sentryrc: $e');
      return {};
    }
  }
}
