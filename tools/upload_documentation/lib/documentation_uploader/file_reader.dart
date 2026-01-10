import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:upload_documentation/documentation_uploader/models/contact_person.dart';
import 'package:upload_documentation/documentation_uploader/models/metadata.dart';
import 'package:upload_documentation/documentation_uploader/models/page.dart';
import 'package:upload_documentation/documentation_uploader/models/table_of_content.dart';
import 'package:upload_documentation/documentation_uploader/models/toc_json_content.dart';
import 'package:yaml/yaml.dart';

class FileReader {
  FileReader({
    required this.isBranch,
    required this.commitHash,
    required this.projectRoot,
  });

  final bool isBranch;
  final String? commitHash;
  final String projectRoot;

  String get docsDirectory => path.join(projectRoot, 'docs');

  Future<String> readFile(String filePath) async {
    // If filePath is relative, make it relative to docs directory
    if (!path.isAbsolute(filePath)) {
      filePath = path.join(docsDirectory, filePath);
    }

    try {
      final file = File(filePath);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('Error reading file: $e');
      rethrow;
    }
  }

  Future<List<String>> listFilesInDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);

    if (directory.existsSync()) {
      final files = <String>[];
      await for (final entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          files.add(entity.path);
        }
      }
      // print(files);
      return files;
    } else {
      print('Directory does not exist');
      throw Exception("Directory doesn't exist");
    }
  }

  Future<List<String>?> readAllowedUsers() async {
    final yamlString = await readFile('metadata.yml');
    var yamlMap = loadYaml(yamlString);
    return (yamlMap['allowedUsers'] as YamlList?)?.map((u) => u as String).toList();
  }

  Future<TableOfContent> readTableOfContent(List<String>? allowedUsers) async {
    final tocString = await readFile('toc.json');
    final aa = jsonDecode(tocString) as Map<String, dynamic>;
    final tocJsonContent = TocJsonContent.fromJson(aa);

    final toc = TableOfContent.fromTocJsonContent(tocJsonContent, allowedUsers);
    return toc;
  }

  Future<Metadata> readMetadata(TableOfContent tableOfContent) async {
    final yamlString = await readFile('metadata.yml');
    var yamlMap = loadYaml(yamlString) as YamlMap;

    final allowedUsers = (yamlMap['allowedUsers'] as YamlList?)?.map((u) => u.toString()).toList();
    final metadata = Metadata(
      name: '${yamlMap['name']}${isBranch ? '-${commitHash!.substring(0, 7)}' : ''}',
      projectId: isBranch ? commitHash! : yamlMap['projectId'] as String,
      description: yamlMap['description'] as String,
      contactPerson: ContactPerson(name: yamlMap['contactName'] as String, email: yamlMap['contactEmail'] as String),
      projectImage: '',
      tableOfContent: tableOfContent,
      isBranch: isBranch,
      allowedUsers: allowedUsers,
    );
    return metadata;
  }

  Future<List<Page>> readPages(TableOfContent tableOfContent) async {
    final files = await listFilesInDirectory(docsDirectory);
    final pageFilepaths =
        files.where((f) => f.endsWith('.md')).map((f) => path.relative(f, from: docsDirectory)).toList();

    final output = <Page>[];
    for (final pageFilepath in pageFilepaths) {
      final content = await readFile(pageFilepath);

      final tocItem = findTocItem(tableOfContent, pageFilepath);
      if (tocItem == null) {
        throw Exception(
          "Couldn't find ToC Item: $pageFilepath",
        );
      }
      output.add(Page(
          id: tocItem.id,
          name: tocItem.tocTitle,
          title: tocItem.pageTitle,
          filePath: pageFilepath,
          content: content,
          onlyAllowedUsers: tocItem.onlyAllowedUsers));
    }

    return output;
  }

  TableOfContent? findTocItem(TableOfContent toc, String pageFilepath) {
    if (toc.filepath == pageFilepath) {
      return toc;
    }
    final possibilities = toc.subpages.map((p) => findTocItem(p, pageFilepath));
    final response = possibilities.where((p) => p != null).firstOrNull;

    return response;
  }
}
