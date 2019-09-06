import 'package:config_builder/annotations/config.dart';

part 'config.g.dart';


enum Environment {
  Dev, Test, Prod
}

@BuildConfiguration([
  ConfigFile(configName: "devConfig", path: "config.dev.json"),
  ConfigFile(configName: "testConfig", path: "config.test.json"),
  ConfigFile(configName: "prodConfig", path: "config.prod.json"),
])
class Config{
  final String name;
  final int value;
  final Environment environment;

  const Config({this.name, this.value, this.environment});


}

