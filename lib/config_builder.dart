library config_builder;

import 'package:build/build.dart';
import 'package:config_builder/generators/config_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder configBuilder(BuilderOptions options) =>
    SharedPartBuilder([ConfigGenerator()], 'config_builder');
