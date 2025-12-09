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
      if (declaration is ClassDeclaration &&
          declaration.metadata.any((m) => m.name.name == 'freezed')) {
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
      final constructor = declaration.members.whereType<ConstructorDeclaration>().firstWhere(
            (m) => m.factoryKeyword != null && m.name?.lexeme == null,
            orElse: () => throw Exception('No default factory constructor found for $className.'),
          );

      final fields = <String, String>{};
      final parameters = constructor.parameters.parameters;

      for (final param in parameters) {
        final parameter = param as DefaultFormalParameter;
        final name = parameter.name!.lexeme;
        final type = (parameter.parameter as SimpleFormalParameter).type!.toSource();

        final tsType = _dartToTsType(type);
        if (tsType == 'Timestamp') {
          needsTimestampImport = true;
        }

        final isNullable = type.endsWith('?');
        fields[name] = '$tsType${isNullable ? ' | null' : ''}';
      }

      if (needsTimestampImport) {
        output.writeln("import { Timestamp } from 'firebase/firestore';");
      }
      output.writeln('export interface $className {');
      fields.forEach((name, type) {
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