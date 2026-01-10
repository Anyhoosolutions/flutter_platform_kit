import 'dart:io';
import 'dart:convert';

/// Generates toc.json by scanning packages and tools directories
class TocGenerator {
  final String projectRoot;
  final String tocPath;

  TocGenerator({
    required this.projectRoot,
    String? tocPath,
  }) : tocPath = tocPath ?? '$projectRoot/docs/toc.json';

  /// Generate and update toc.json
  Future<void> generate() async {
    print('🔍 Scanning packages and tools for documentation files...');
    print('📂 Project root: $projectRoot');
    print('📄 TOC path: $tocPath');

    // Read existing toc.json to preserve top-level structure
    final existingToc = await _readExistingToc();

    // Generate package sections
    print('\n📦 Generating packages section...');
    final flutterPackagesSection = await _generatePackagesSection('packages');
    print('✅ Found ${flutterPackagesSection.length} packages');

    print('\n🔧 Generating tools section...');
    final toolsSection = await _generatePackagesSection('tools');
    print('✅ Found ${toolsSection.length} tools');

    // Find the flutter_packages and tools sections in existing toc
    final updatedSubpages = _updateSubpages(
      existingToc['subpages'] as List<dynamic>,
      flutterPackagesSection,
      toolsSection,
    );

    // Create updated toc
    final updatedToc = {
      ...existingToc,
      'subpages': updatedSubpages,
    };

    // Write updated toc.json
    await _writeToc(updatedToc);
    print('\n✅ Successfully updated toc.json');
  }

  /// Read existing toc.json
  Future<Map<String, dynamic>> _readExistingToc() async {
    final file = File(tocPath);
    if (!await file.exists()) {
      throw Exception('toc.json not found at $tocPath');
    }
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  /// Generate sections for packages or tools
  Future<List<Map<String, dynamic>>> _generatePackagesSection(String directory) async {
    final packagesDir = Directory('$projectRoot/$directory');
    print('📁 Scanning directory: ${packagesDir.path}');
    if (!await packagesDir.exists()) {
      print('⚠️  Directory does not exist: ${packagesDir.path}');
      return [];
    }

    final packages = <Map<String, dynamic>>[];
    int dirCount = 0;

    await for (final entity in packagesDir.list()) {
      if (entity is Directory) {
        dirCount++;
        final packageName = entity.path.split('/').last;
        print('  📦 Found package: $packageName');
        final packageDocs = await _generatePackageDocs(packageName, directory);
        if (packageDocs != null) {
          packages.add(packageDocs);
          print('  ✅ Added package: $packageName');
        } else {
          print('  ⚠️  Skipped package: $packageName (no README.md)');
        }
      }
    }

    print('📊 Found $dirCount directories, added ${packages.length} packages');

    // Sort packages alphabetically
    packages.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

    return packages;
  }

  /// Generate documentation structure for a single package
  Future<Map<String, dynamic>?> _generatePackageDocs(String packageName, String baseDir) async {
    final packageDir = Directory('$projectRoot/$baseDir/$packageName');
    if (!await packageDir.exists()) {
      return null;
    }

    // Check if README.md exists
    final readmePath = File('${packageDir.path}/README.md');
    if (!await readmePath.exists()) {
      return null; // Skip packages without README
    }

    // Get package display name (convert snake_case to Title Case)
    final displayName = _toTitleCase(packageName);

    // Find all documentation files
    final subpages = <Map<String, dynamic>>[];

    // Always add CHANGELOG.md if it exists
    final changelogPath = File('${packageDir.path}/CHANGELOG.md');
    if (await changelogPath.exists()) {
      subpages.add({
        'filepath': '$packageName/CHANGELOG.md',
        'name': 'Changelog',
        'title': 'Changelog',
        'subpages': [],
      });
    }

    // Find files in docs/ directory
    final docsDir = Directory('${packageDir.path}/docs');
    if (await docsDir.exists()) {
      await for (final entity in docsDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.md')) {
          final relativePath = entity.path.replaceFirst('${packageDir.path}/docs/', '');
          final docName = _getDocName(relativePath);
          subpages.add({
            'filepath': '$packageName/$relativePath',
            'name': docName,
            'title': docName,
            'subpages': [],
          });
        }
      }
    }

    // Find additional .md files in package root (excluding README.md and CHANGELOG.md)
    await for (final entity in packageDir.list()) {
      if (entity is File &&
          entity.path.endsWith('.md') &&
          !entity.path.endsWith('README.md') &&
          !entity.path.endsWith('CHANGELOG.md')) {
        final filename = entity.path.split('/').last;
        final docName = _getDocName(filename);
        subpages.add({
          'filepath': '$packageName/$filename',
          'name': docName,
          'title': docName,
          'subpages': [],
        });
      }
    }

    // Sort subpages: Changelog first, then alphabetically
    subpages.sort((a, b) {
      if (a['name'] == 'Changelog') return -1;
      if (b['name'] == 'Changelog') return 1;
      return (a['name'] as String).compareTo(b['name'] as String);
    });

    return {
      'filepath': '$packageName/README.md',
      'name': displayName,
      'title': displayName,
      'subpages': subpages,
    };
  }

  /// Get a display name from a filename (remove .md, convert to Title Case)
  String _getDocName(String filename) {
    var name = filename.replaceAll('.md', '').replaceAll('_', ' ').replaceAll('-', ' ');
    // Convert to Title Case
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Convert snake_case to Title Case
  String _toTitleCase(String text) {
    return text.split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Update subpages in existing toc, replacing flutter_packages and tools sections
  List<dynamic> _updateSubpages(
    List<dynamic> existingSubpages,
    List<Map<String, dynamic>> flutterPackages,
    List<Map<String, dynamic>> tools,
  ) {
    print('\n🔄 Updating subpages...');
    print('  📦 Flutter packages to add: ${flutterPackages.length}');
    print('  🔧 Tools to add: ${tools.length}');

    bool hasFlutterPackages = false;
    bool hasTools = false;

    // Update existing subpages and check if flutter_packages and tools exist
    final updatedSubpages = existingSubpages.map((subpage) {
      final subpageMap = subpage as Map<String, dynamic>;
      final filepath = subpageMap['filepath'] as String;

      // Replace flutter_packages.md section
      if (filepath == 'flutter_packages.md') {
        hasFlutterPackages = true;
        print('  ✅ Found flutter_packages.md, updating with ${flutterPackages.length} packages');
        return {
          ...subpageMap,
          'subpages': flutterPackages,
        };
      }

      // Replace tools.md section
      if (filepath == 'tools.md') {
        hasTools = true;
        print('  ✅ Found tools.md, updating with ${tools.length} tools');
        return {
          ...subpageMap,
          'subpages': tools,
        };
      }

      // Keep other subpages as-is
      return subpageMap;
    }).toList();

    // Convert to mutable list
    final result = <dynamic>[...updatedSubpages];

    // Add flutter_packages.md if it doesn't exist
    if (!hasFlutterPackages && flutterPackages.isNotEmpty) {
      print('  ➕ Adding flutter_packages.md section with ${flutterPackages.length} packages');
      result.add({
        'filepath': 'flutter_packages.md',
        'name': 'Flutter packages',
        'title': 'Flutter packages',
        'subpages': flutterPackages,
      });
    }

    // Add tools.md if it doesn't exist
    if (!hasTools && tools.isNotEmpty) {
      print('  ➕ Adding tools.md section with ${tools.length} tools');
      result.add({
        'filepath': 'tools.md',
        'name': 'Tools',
        'title': 'Tools',
        'subpages': tools,
      });
    }

    return result;
  }

  /// Write updated toc.json
  Future<void> _writeToc(Map<String, dynamic> toc) async {
    final file = File(tocPath);
    const encoder = JsonEncoder.withIndent('\t');
    await file.writeAsString(encoder.convert(toc));
  }
}
