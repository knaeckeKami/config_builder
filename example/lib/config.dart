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

  const Config(
      {required this.name,
      required this.value,
      required this.environment,
      required this.number});
}
