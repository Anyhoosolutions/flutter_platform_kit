import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:logging/logging.dart';

final _log = Logger('FreezedToTsConverter');

class FreezedToTsConverter {
  final Set<String> _knownFreezedClasses = {};

  void learn(String dartCode) {
    final classNameLine = dartCode.split('\n').firstWhere((line) => line.contains('class '));
    final classPosition = classNameLine.indexOf('class ');
    final className = classNameLine.substring(classPosition + 5).trim().split(' ').first;
    _log.info('Learning $className');
    final parseResult = parseString(
      content: dartCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );
    final compilationUnit = parseResult.unit;

    for (final declaration in compilationUnit.declarations) {
      if (declaration is ClassDeclaration && declaration.metadata.any((m) => m.name.name == 'freezed')) {
        _knownFreezedClasses.add(declaration.name.lexeme);
      }
    }
  }

  String convert(String dartCode) {
    final parseResult = parseString(
      content: dartCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );
    final compilationUnit = parseResult.unit;
    final output = StringBuffer();
    bool needsTimestampImport = false;
    final Set<String> referencedFreezedClasses = {};
    final Map<String, String> importMap = {}; // Maps class name to import path

    // Parse imports to build a map of class names to their import paths
    for (final directive in compilationUnit.directives) {
      if (directive is ImportDirective) {
        final importPath = directive.uri.stringValue;
        if (importPath != null && !importPath.startsWith('package:')) {
          // This is a relative import (e.g., 'address.dart')
          // We'll need to check which classes from this file are used
          // For now, we'll store the import path and match it later
          final tsImportPath = _convertDartImportToTs(importPath);
          // Extract class name from file name (e.g., 'address.dart' -> 'Address')
          // This is a heuristic - we'll match it with actual class names later
          importMap[tsImportPath] = tsImportPath;
        }
      }
    }

    for (final declaration in compilationUnit.declarations) {
      if (declaration is! ClassDeclaration) continue;

      final isFreezed = declaration.metadata.any((m) => m.name.name == 'freezed');
      if (!isFreezed) continue;

      final className = declaration.name.lexeme;
      final factoryConstructors = declaration.members.whereType<ConstructorDeclaration>().where(
            (m) => m.factoryKeyword != null,
          );

      if (factoryConstructors.isEmpty) {
        throw Exception(
            'No factory constructors found for $className. Freezed classes should have at least one factory constructor.');
      }

      final allFields = <String, String>{}; // Map to store unique fields across all constructors

      for (final constructor in factoryConstructors) {
        if (constructor.name?.lexeme == 'fromJson') {
          continue;
        }
        for (final param in constructor.parameters.parameters) {
          String originalName;
          TypeAnnotation? paramTypeAnnotation;

          if (param is DefaultFormalParameter) {
            originalName = param.name!.lexeme;
            paramTypeAnnotation = (param.parameter as SimpleFormalParameter).type;
          } else if (param is FieldFormalParameter) {
            originalName = param.name.lexeme;
            paramTypeAnnotation = param.type;
          } else if (param is SimpleFormalParameter) {
            originalName = param.name!.lexeme;
            paramTypeAnnotation = param.type;
          } else {
            continue; // Skip unsupported parameter types
          }

          if (paramTypeAnnotation == null) continue;

          var name = originalName;
          final type = paramTypeAnnotation.toSource();
          var finalTsType = _dartToTsType(type);

          // Track referenced freezed classes (including those inside generics)
          _extractReferencedFreezedClasses(type, className, referencedFreezedClasses);

          // Existing JsonKey processing for 'name', 'fromJson', 'toJson'
          for (final annotation in param.metadata) {
            if (annotation.name.name == 'JsonKey' && annotation.arguments != null) {
              String? jsonKeyName;

              for (final arg in annotation.arguments!.arguments) {
                if (arg is NamedExpression) {
                  if (arg.name.label.name == 'name' && arg.expression is StringLiteral) {
                    jsonKeyName = (arg.expression as StringLiteral).stringValue;
                  }
                }
              }

              if (jsonKeyName != null) {
                name = jsonKeyName;
              }
            }
          }

          if (finalTsType == 'Timestamp') {
            needsTimestampImport = true;
          }

          final isNullable = type.endsWith('?');
          allFields[name] = '$finalTsType${isNullable ? ' | null' : ''}';
        }
      }

      // Collect all imports and sort them according to Biome's default order:
      // 1. External packages (e.g., 'firebase/firestore')
      // 2. Relative imports (e.g., './address.ts')
      // Within each group, sorted alphabetically
      final List<String> externalImports = [];
      final List<String> relativeImports = [];

      // Add Timestamp import if needed
      if (needsTimestampImport) {
        externalImports.add("import type { Timestamp } from 'firebase-admin/firestore';");
      }

      // Generate imports for referenced freezed classes
      for (final referencedClass in referencedFreezedClasses) {
        // Find the import path for this class
        String? importPath;

        // First, try to find a matching relative import
        for (final directive in compilationUnit.directives) {
          if (directive is ImportDirective) {
            final dartImportPath = directive.uri.stringValue;
            if (dartImportPath != null && !dartImportPath.startsWith('package:')) {
              // Relative import: Convert Dart import path to TypeScript import path
              importPath = _convertDartImportToTs(dartImportPath);
              break; // Use the first relative import found
            }
          }
        }

        // If no relative import found, try to find a matching package import
        if (importPath == null) {
          final expectedFileName = _classNameToFileName(referencedClass);
          for (final directive in compilationUnit.directives) {
            if (directive is ImportDirective) {
              final dartImportPath = directive.uri.stringValue;
              if (dartImportPath != null && dartImportPath.startsWith('package:')) {
                // Package import: Extract file name and check if it matches the class name
                final fileName = _extractFileNameFromPackageImport(dartImportPath);
                if (fileName != null && fileName == expectedFileName) {
                  importPath = _convertDartImportToTs(fileName);
                  break; // Use the matching package import
                }
              }
            }
          }
        }

        // If still no match found, use the first package import as fallback
        if (importPath == null) {
          for (final directive in compilationUnit.directives) {
            if (directive is ImportDirective) {
              final dartImportPath = directive.uri.stringValue;
              if (dartImportPath != null && dartImportPath.startsWith('package:')) {
                final fileName = _extractFileNameFromPackageImport(dartImportPath);
                if (fileName != null) {
                  importPath = _convertDartImportToTs(fileName);
                  break; // Use the first package import as fallback
                }
              }
            }
          }
        }

        if (importPath != null) {
          relativeImports.add("import type { $referencedClass } from '$importPath';");
        }
      }

      // Sort imports alphabetically within each group
      externalImports.sort();
      relativeImports.sort();

      // Output imports in Biome's default order: external first, then relative
      for (final import in externalImports) {
        output.writeln(import);
      }
      for (final import in relativeImports) {
        output.writeln(import);
      }

      // Add blank line only if there are relative imports
      if (relativeImports.isNotEmpty) {
        output.writeln('');
      }
      output.writeln('export interface $className {');
      allFields.forEach((name, type) {
        output.writeln('  $name: $type;');
      });
      output.writeln('}');
    }

    return output.toString();
  }

  void _extractReferencedFreezedClasses(String type, String currentClassName, Set<String> referencedClasses) {
    // Remove nullable marker
    final baseType = type.endsWith('?') ? type.substring(0, type.length - 1) : type;

    // Check if it's a generic type (e.g., List<RecipeShort>)
    if (baseType.startsWith('List<')) {
      final innerType = baseType.substring(5, baseType.length - 1);
      _extractReferencedFreezedClasses(innerType, currentClassName, referencedClasses);
    } else if (baseType.startsWith('Map<')) {
      // For Map<K, V>, extract both key and value types
      final innerPart = baseType.substring(4, baseType.length - 1);
      final commaIndex = innerPart.indexOf(',');
      if (commaIndex != -1) {
        final keyType = innerPart.substring(0, commaIndex).trim();
        final valueType = innerPart.substring(commaIndex + 1).trim();
        _extractReferencedFreezedClasses(keyType, currentClassName, referencedClasses);
        _extractReferencedFreezedClasses(valueType, currentClassName, referencedClasses);
      }
    } else {
      // Check if this type is a known freezed class
      if (_knownFreezedClasses.contains(baseType) && baseType != currentClassName) {
        referencedClasses.add(baseType);
      }
    }
  }

  String _classNameToFileName(String className) {
    // Convert class name to snake_case file name
    // e.g., 'RecipeShort' -> 'recipe_short.dart'
    final buffer = StringBuffer();
    for (int i = 0; i < className.length; i++) {
      final char = className[i];
      if (char == char.toUpperCase() && i > 0) {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    }
    return '${buffer.toString()}.dart';
  }

  String? _extractFileNameFromPackageImport(String packageImport) {
    // Extract file name from package import
    // e.g., 'package:snapandsavor/sharedModels/recipe_short.dart' -> 'recipe_short.dart'
    if (packageImport.startsWith('package:')) {
      final path = packageImport.substring(8); // Remove 'package:' prefix
      final parts = path.split('/');
      if (parts.isNotEmpty) {
        final fileName = parts.last;
        if (fileName.endsWith('.dart')) {
          return fileName;
        }
      }
    }
    return null;
  }

  String _convertDartImportToTs(String dartImport) {
    // Convert 'address.dart' to './address.ts'
    if (dartImport.endsWith('.dart')) {
      return './${dartImport.substring(0, dartImport.length - 5)}.ts';
    }
    return './$dartImport.ts';
  }

  String _dartToTsType(String dartType) {
    if (dartType.endsWith('?')) {
      dartType = dartType.substring(0, dartType.length - 1);
    }

    switch (dartType) {
      case 'String':
        return 'string';
      case 'int':
      case 'double':
      case 'num':
        return 'number';
      case 'bool':
        return 'boolean';
      case 'DateTime':
        return 'Timestamp';
      case 'dynamic':
      case 'Object':
        return 'any';
      default:
        if (_knownFreezedClasses.contains(dartType)) {
          return dartType;
        }
        if (dartType.startsWith('List<')) {
          final innerType = dartType.substring(5, dartType.length - 1);
          return '${_dartToTsType(innerType)}[]';
        }
        if (dartType.startsWith('Map<')) {
          return '{ [key: string]: any }'; // Simplified for now
        }
        return dartType; // For custom types, assume they exist in TS
    }
  }
}
