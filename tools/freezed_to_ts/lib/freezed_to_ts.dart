import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

class FreezedToTsConverter {
  final Set<String> _knownFreezedClasses = {};

  void learn(String dartCode) {
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

      if (needsTimestampImport) {
        output.writeln("import { Timestamp } from 'firebase/firestore';");
      }
      output.writeln('export interface $className {');
      allFields.forEach((name, type) {
        output.writeln('  $name: $type;');
      });
      output.writeln('}');
    }

    return output.toString();
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
