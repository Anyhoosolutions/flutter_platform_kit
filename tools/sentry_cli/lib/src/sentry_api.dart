import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';

/// A single Sentry issue from the API.
class SentryIssue {
  final String id;
  final String shortId;
  final String title;
  final String culprit;
  final String level;
  final String status;
  final int count;
  final int userCount;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final String? type;
  final String? value;
  final String permalink;

  SentryIssue({
    required this.id,
    required this.shortId,
    required this.title,
    required this.culprit,
    required this.level,
    required this.status,
    required this.count,
    required this.userCount,
    required this.firstSeen,
    required this.lastSeen,
    this.type,
    this.value,
    required this.permalink,
  });

  factory SentryIssue.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return SentryIssue(
      id: json['id'] as String,
      shortId: json['shortId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      culprit: json['culprit'] as String? ?? '',
      level: json['level'] as String? ?? 'error',
      status: json['status'] as String? ?? '',
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      userCount: json['userCount'] as int? ?? 0,
      firstSeen: DateTime.tryParse(json['firstSeen'] as String? ?? '') ??
          DateTime.now(),
      lastSeen: DateTime.tryParse(json['lastSeen'] as String? ?? '') ??
          DateTime.now(),
      type: metadata['type'] as String?,
      value: metadata['value'] as String?,
      permalink: json['permalink'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'shortId': shortId,
        'title': title,
        'culprit': culprit,
        'level': level,
        'status': status,
        'count': count,
        'userCount': userCount,
        'firstSeen': firstSeen.toIso8601String(),
        'lastSeen': lastSeen.toIso8601String(),
        'type': type,
        'value': value,
        'permalink': permalink,
      };
}

/// A Sentry project from the API.
class SentryProject {
  final String slug;
  final String name;
  final String? platform;
  final String status;
  final DateTime dateCreated;

  SentryProject({
    required this.slug,
    required this.name,
    this.platform,
    required this.status,
    required this.dateCreated,
  });

  factory SentryProject.fromJson(Map<String, dynamic> json) {
    return SentryProject(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      platform: json['platform'] as String?,
      status: json['status'] as String? ?? 'active',
      dateCreated:
          DateTime.tryParse(json['dateCreated'] as String? ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'name': name,
        'platform': platform,
        'status': status,
        'dateCreated': dateCreated.toIso8601String(),
      };
}

/// Client for the Sentry API.
class SentryApiClient {
  static const _baseUrl = 'https://sentry.io/api/0';

  final SentryConfig config;
  final http.Client _client;

  SentryApiClient({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  /// Build the search query string from convenience flags + raw query.
  static String buildQuery({
    String? rawQuery,
    String? level,
    bool unresolved = true,
    bool all = false,
    String? release,
    String? environment,
  }) {
    final parts = <String>[];

    if (!all && unresolved) {
      parts.add('is:unresolved');
    }
    if (level != null) {
      parts.add('level:$level');
    }
    if (release != null) {
      parts.add('release:$release');
    }
    if (environment != null) {
      parts.add('environment:$environment');
    }
    if (rawQuery != null && rawQuery.isNotEmpty) {
      parts.add(rawQuery);
    }

    return parts.join(' ');
  }

  /// List all projects for the configured organization.
  Future<List<SentryProject>> listProjects() async {
    final uri = Uri.parse(
      '$_baseUrl/organizations/${config.org}/projects/',
    );

    final response = await _request(uri);
    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((e) => SentryProject.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// List issues for the configured project.
  Future<List<SentryIssue>> listIssues({
    String query = 'is:unresolved',
    String sort = 'date',
    int limit = 25,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/projects/${config.org}/${config.project}/issues/',
    ).replace(queryParameters: {
      'query': query,
      'sort': sort,
      if (limit > 0) 'limit': limit.toString(),
    });

    final response = await _request(uri);
    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((e) => SentryIssue.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get a single issue by ID (numeric) or short ID (e.g. FLUTTER-17).
  Future<Map<String, dynamic>> getIssue(String issueId) async {
    final resolved = await _resolveIssueId(issueId);
    final uri = Uri.parse('$_baseUrl/issues/$resolved/');
    final response = await _request(uri);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get the latest event for an issue (includes stacktrace).
  Future<Map<String, dynamic>> getLatestEvent(String issueId) async {
    final resolved = await _resolveIssueId(issueId);
    final uri = Uri.parse('$_baseUrl/issues/$resolved/events/latest/');
    final response = await _request(uri);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Resolve a short ID (e.g. FLUTTER-17) to a numeric issue ID.
  /// If the ID is already numeric, returns it as-is.
  Future<String> _resolveIssueId(String issueId) async {
    // If it's purely numeric, use directly
    if (int.tryParse(issueId) != null) return issueId;

    // Otherwise treat it as a short ID and resolve via the org endpoint
    final uri = Uri.parse(
      '$_baseUrl/organizations/${config.org}/shortids/$issueId/',
    );
    final response = await _request(uri);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['groupId'] as String;
  }

  Future<http.Response> _request(Uri uri) async {
    final response = await _client.get(uri, headers: {
      'Authorization': 'Bearer ${config.token}',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw SentryApiException(
        statusCode: response.statusCode,
        message: _parseError(response.body),
        url: uri.toString(),
      );
    }

    return response;
  }

  String _parseError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['detail'] as String? ?? body;
    } catch (_) {
      return body;
    }
  }

  void close() => _client.close();
}

class SentryApiException implements Exception {
  final int statusCode;
  final String message;
  final String url;

  SentryApiException({
    required this.statusCode,
    required this.message,
    required this.url,
  });

  @override
  String toString() => 'Sentry API error ($statusCode): $message\n  URL: $url';
}
