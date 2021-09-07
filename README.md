[![Pub Package](https://img.shields.io/pub/v/config_builder.svg)](https://pub.dartlang.org/packages/config_builder)


# config_builder


Build your app config via code generation from .json files. Type-Safe and no unnecessary IO/Parsing on app-startup!



## Features

- Avoid storing your configuration in dart files
- Avoid reading config files from disk and parsing them at app start
- Type safe
- Supports String, bool, int, double, Enums, Lists of these types, and nested objects of these types (see example)


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
  ConfigFile(configName: "devConfig", path: "lib/secrets/config.dev.json"),
  ConfigFile(configName: "testConfig", path: "lib/secrets/config.test.json"),
])
class Config{
  final String name;
  final int value;
  final Environment environment;

  const Config({this.name, this.value, this.environment});
}
```

Make sure the config-class has exactly one `const` constructor with exclusively required, named parameters.
The generated code will assume that such a constructor exists.

If you use nested config classes, they also must have exactly one constructor exclusively required, named parameters.

Add your configuration-json file (must be saved in the lib/ directory):

```json
{
  "name" : "devApp",
  "value": 1,
  "environment" : "Dev"
}
```


Run the code generation via 

    flutter pub run build_runner build
(flutter projects)    
or
 
     dart run build_runner build 
(dart-only projects)   
    
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
