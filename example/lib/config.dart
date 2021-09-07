import 'package:config_builder/annotations/config.dart';

part 'config.g.dart';

enum Environment { Dev, Test, Prod }

@BuildConfiguration([
  ConfigFile(configName: "devConfig", path: "lib/secrets/config.dev.json"),
  ConfigFile(configName: "testConfig", path: "lib/secrets/config.test.json"),
  ConfigFile(configName: "prodConfig", path: "lib/secrets/config.prod.json"),
])
class Config {
  final String name;
  final int value;
  final Environment environment;
  final double number;
  final List<String> stringList;
  final List<List<int>> nestedIntList;
  final List<AnotherNestedConfig> nestedObjectList;

  final NestedConfig nestedConfig;

  const Config({
    required this.name,
    required this.value,
    required this.environment,
    required this.number,
    required this.stringList,
    required this.nestedIntList,
    required this.nestedConfig,
    required this.nestedObjectList
  });
}

class NestedConfig {
  final int nestedInt;
  final AnotherNestedConfig evenMoreNestedConfig;

  const NestedConfig(
      {required this.nestedInt, required this.evenMoreNestedConfig});
}

class AnotherNestedConfig {
  final String value;

  const AnotherNestedConfig({required this.value});
}
