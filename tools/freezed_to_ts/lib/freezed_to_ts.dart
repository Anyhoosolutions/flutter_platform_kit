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

          // Track referenced freezed classes
          final baseType = type.endsWith('?') ? type.substring(0, type.length - 1) : type;
          if (_knownFreezedClasses.contains(baseType) && baseType != className) {
            referencedFreezedClasses.add(baseType);
          }

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
        for (final directive in compilationUnit.directives) {
          if (directive is ImportDirective) {
            final dartImportPath = directive.uri.stringValue;
            if (dartImportPath != null && !dartImportPath.startsWith('package:')) {
              // Convert Dart import path to TypeScript import path
              importPath = _convertDartImportToTs(dartImportPath);
              break; // Use the first relative import found
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
