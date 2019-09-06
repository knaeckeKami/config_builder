
class BuildConfiguration{
  final List<ConfigFile> configFiles;

  const BuildConfiguration(this.configFiles);
}


class ConfigFile {
  final String configName;
  final String path;

  const ConfigFile({this.configName, this.path});
}

