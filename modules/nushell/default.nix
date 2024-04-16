{ config, specialArgs, pkgs, lib, ... }:

with specialArgs; # for flakePkgs
{
  options.my.nushell = {
    left_prompt_cmd = lib.mkOption { default = "hostname -s"; type = lib.types.str; description = "Command to use to generate left prompt text"; };
    history_file_format = lib.mkOption { default = "sqlite"; type = lib.types.str; description = "History file format, either sqlite or plaintext"; };
  };

  config = {
    programs = {
      nushell = {
        enable = true;
        package = pkgs.nushellFull;
        configFile.text = (builtins.replaceStrings ["HISTORY_FILE_FORMAT"] [config.my.nushell.history_file_format] (builtins.readFile ./config.nu));
        envFile.text = ''
          # Nushell Environment Config File

          def create_left_prompt [] {
              let hostname_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
              $"($hostname_color)(${config.my.nushell.left_prompt_cmd})(ansi reset)"
          }

        '' + (builtins.readFile ./env.nu);
      };

      direnv.enableNushellIntegration = true;
    };

    home.file = {
      ".config/nushell/plugins/nu_plugin_bash_env".source = "${flakePkgs.nu_plugin_bash_env}/bin/nu_plugin_bash_env";
    };
  };
}
