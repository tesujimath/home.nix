{ config, specialArgs, pkgs, ... }:

with specialArgs; # for flakePkgs
{
  config = {
    programs = {
      nushell = {
        enable = true;
        package = pkgs.nushellFull;
        configFile.source = ./config.nu;
        envFile.source = ./env.nu;
      };

      direnv.enableNushellIntegration = true;
    };

    home.file = {
      ".config/nushell/plugins/nu_plugin_bash_env".source = "${flakePkgs.nu_plugin_bash_env}/bin/nu_plugin_bash_env";
    };
  };
}
