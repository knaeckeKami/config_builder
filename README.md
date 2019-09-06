[![Pub Package](https://img.shields.io/pub/v/config_builder.svg)](https://pub.dartlang.org/packages/config_builder)


# config_builder


Build your app config via code generation from .json files. Type-Safe and no unnecessary IO/Parsing on app-startup!

Note: this is an experimental library. Use with caution!

## Features

- Avoid storing your configuration in dart files
- Avoid reading config files from disk and parsing them at app start
- Type safe
- Supports String, bool, int, double and Enums


## How to use

Add to your devDependencies (see example):

```yaml
dev_dependencies:
  build_runner: <version>
  config_builder: <version>
```

Define your configuration model:

```dart
part 'config.g.dart'; //use the <filename>.g.dart, where <filename> is the name of this dart file

@BuildConfiguration([
  ConfigFile(configName: "devConfig", path: "config.dev.json"),
  ConfigFile(configName: "testConfig", path: "config.test.json"),
])
class Config{
  final String name;
  final int value;
  final Environment environment;

  const Config({this.name, this.value, this.environment});
}
```

Make sure the config-class has a `const` constructor with exclusively named parameters.
The generated code will assume that such a constructor exists.

Add your configuration-json file:

```json
{
  "name" : "devApp",
  "value": 1,
  "environment" : "Dev"
}
```


Run the code generation via 

    flutter packages pub run build_runner build
    
Now you can access your config object for example via different entry points in your app:

`main.dev.dart`:

```dart
import 'config.dart';

void main() => printConfig(devConfig);
```

`main.test.dart`:

```dart
import 'config.dart';

void main() => printConfig(testConfig);
```

## known issues

- build_runner caches the result and won't collect changes in your config files if none of your source files changed since the last build
I'll look into how this can be fixes. In the meantime, just add a new line somewhere in your config.dart file to force a new build.