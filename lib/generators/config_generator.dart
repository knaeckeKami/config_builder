import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:config_builder/annotations/config.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class ConfigGenerator extends GeneratorForAnnotation<BuildConfiguration> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw 'This annotation can only be used on classes. Offending Element: $element';
    }
    final classElement = element as ClassElement;
    final configList = annotation.read("configFiles")?.listValue;

    if (configList == null || configList.isEmpty) {
      throw 'configFiles list cannot be empty!  Offending Element: $element';
    }

    final buffer = StringBuffer();

    for (final configFile in configList) {
      final String code = generateCodeForFile(configFile, classElement);
      buffer.write(code);
    }
    print(buffer.toString());
    return buffer.toString();
  }

  String generateCodeForFile(DartObject configFile, ClassElement classElement) {
    final filePath = configFile.getField('path')?.toStringValue();
    if (filePath == null) {
      throw "configFiles must have a valid path and configName parameter! Offending Element: $classElement";
    }
    final file = File(filePath);
    if (!file.existsSync()) {
      throw "$filePath isn't readable!";
    }
    final configAsString = File(filePath).readAsStringSync();
    final Map<String, dynamic> parsedConfig = json.decode(configAsString);

    final configName = configFile.getField('configName')?.toStringValue();
    if (configName == null) {
      throw "configFiles must have a valid path and configName parameter! Offending Element: $classElement";
    }
    return generateField(configName, classElement, parsedConfig);
  }

  String generateField(String variableName, ClassElement classElement,
      Map<String, dynamic> parsedConfig) {
    return """const $variableName = ${classElement.name}(
  ${parsedConfig.entries.map((pair) => generateVariable(classElement, pair.key, pair.value)).join(",")}
  );""";
  }

  String generateVariable(
      ClassElement element, String variableName, dynamic rawValue) {
    final field = element.getField(variableName.trim());
    if (field == null) {
      throw ("field not found: $variableName");
    }
    String value;
    if (field.type.isDartCoreString) {
      value = 'r"""' + rawValue.toString() + '"""';
    } else if (field.type.isDartCoreBool) {
      if (rawValue is! bool) {
        throw "$variableName should be a bool, but got $rawValue (${rawValue.runtimeType})";
      }
      value = rawValue.toString();
    } else if (field.type.isDartCoreInt) {
      if (rawValue is! int) {
        throw "$variableName should be an int, but got $rawValue (${rawValue.runtimeType})";
      }
      value = rawValue.toString();
    } else if (field.type.isDartCoreDouble) {
      value = double.parse(rawValue).toString();
    } else if (field.type.element.runtimeType.toString() == "EnumElementImpl") {
      value = "${field.type.name}.$rawValue";
    } else {
      throw "unsupported type: ${field.type}";
    }
    return "$variableName:$value";
  }
}
