import 'package:config_builder_example/config.dart';
import 'package:config_builder_example/do_stuff_with_config.dart';

void main(){
  // run 'flutter packages pub run build_runner build' to generate the code
  final Config config = prodConfig;
  printConfig(config);
}