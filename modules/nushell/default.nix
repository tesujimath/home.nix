{ config, specialArgs, ... }:

with specialArgs; # for flakePkgs
{
  config = {
    programs = {
      nushell = {
        enable = true;
        configFile.source = ./config.nu;
        envFile.source = ./env.nu;
      };

      direnv.enableNushellIntegration = true;
    };

    home.packages = [
      flakePkgs.nu_plugin_bash_env
    ];
  };
}
