import 'dart:convert';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:config_builder/annotations/config.dart';
import 'package:source_gen/source_gen.dart';
import 'package:glob/glob.dart';

class ConfigGenerator extends GeneratorForAnnotation<BuildConfiguration> {
  @override
  Future<String> generateForAnnotatedElement(Element classElement,
      ConstantReader annotation, BuildStep buildStep) async {
    if (classElement is! ClassElement) {
      throw 'This annotation can only be used on classes. Offending Element: $classElement';
    }

    final configList = annotation.read('configFiles')?.listValue;

    if (configList == null || configList.isEmpty) {
      throw 'configFiles list cannot be empty!  Offending Element: $classElement';
    }

    final buffer = StringBuffer();

    for (final configFile in configList) {
      final filePath = configFile.getField('path')?.toStringValue();
      if (filePath == null) {
        throw "error: path was null in ${configFile} from at annotation ${annotation}";
      }
      final assets = await buildStep
          .findAssets(Glob(filePath, caseSensitive: true))
          .toList();
      if (assets.isEmpty) {
        throw "no file found for argument $filePath";
      }
      if (assets.length > 1) {
        throw "error: multiple files found that match $filePath!";
      }
      final assetId = assets.first;
      final jsonString = await buildStep.readAsString(assetId);
      final configName = configFile.getField('configName')?.toStringValue();
      final code =
          generateCodeForFile(filePath, classElement, jsonString, configName);
      buffer.write(code);
    }
    return buffer.toString();
  }

  String generateCodeForFile(String? filePath, ClassElement classElement,
      String jsonString, String? configName) {
    if (filePath == null) {
      throw 'configFiles must have a valid path and configName parameter! Offending Element: $classElement';
    }
    try {
      final Map<String, dynamic> parsedConfig = json.decode(jsonString);

      if (configName == null) {
        throw 'configFiles must have a valid path and configName parameter! Offending Element: $classElement';
      }
      return generateField(configName, classElement, parsedConfig, filePath);
    } on FormatException {
      print("invalid json for file $filePath!");
      rethrow;
    }
  }

  String generateField(String variableName, ClassElement classElement,
      Map<String, dynamic> parsedConfig, String filePath) {
    return """const $variableName = ${classElement.name}(
  ${parsedConfig.entries.map((pair) => generateValueForVariable(classElement, pair.key, pair.value, filePath)).join(",")}
  );""";
  }

  String generateValueForVariable(ClassElement element, String variableName,
      dynamic rawValue, String filePath) {
    final FieldElement? field = element.getField(variableName.trim());
    if (field == null) {
      throw ('field $variableName not found for class $element, but it was set in your config json file $filePath!');
    }
    String value;
    final fieldElement = field.type.element;
    if (field.type.isDartCoreString) {
      value = asDartLiteral(rawValue.toString());
    } else if (field.type.isDartCoreBool) {
      if (rawValue is! bool) {
        throw '$variableName should be a bool, but got $rawValue (${rawValue.runtimeType})';
      }
      value = rawValue.toString();
    } else if (field.type.isDartCoreInt) {
      if (rawValue is! int) {
        throw '$variableName should be an int, but got $rawValue (${rawValue.runtimeType})';
      }
      value = rawValue.toString();
    } else if (field.type.isDartCoreDouble) {
      if (rawValue is! num) {
        throw '$variableName should be a double, but got $rawValue (${rawValue.runtimeType})';
      }
      value = rawValue.toString();
    } else if (fieldElement is ClassElement && fieldElement.isEnum) {
      //TODO add nullability support
      value =
          '${field.type.getDisplayString(withNullability: false)}.$rawValue';
    } else {
      throw 'unsupported type: ${field.type}';
    }
    return '$variableName:$value';
  }
}

String asDartLiteral(String value) {
  final escaped = escapeForDart(value);
  return "'$escaped'";
}

String escapeForDart(String value) {
  return value
      .replaceAll("'", "\\'")
      .replaceAll('\$', '\\\$')
      .replaceAll('\r', '\\r')
      .replaceAll('\n', '\\n');
}
