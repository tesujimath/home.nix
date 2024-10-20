{ config, specialArgs, pkgs, lib, ... }:

let
  cfg = config.local.nushell;
  inherit (lib) mkEnableOption mkIf;
  inherit (specialArgs) flakePkgs;
in
{
  options.local.nushell = {
    enable = mkEnableOption "nushell";
    left_prompt_cmd = lib.mkOption { default = "hostname -s"; type = lib.types.str; description = "Command to use to generate left prompt text"; };
    history_file_format = lib.mkOption { default = "sqlite"; type = lib.types.str; description = "History file format, either sqlite or plaintext"; };
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
        configFile.text = (builtins.replaceStrings [
          "HISTORY_FILE_FORMAT"
          "NIX_BASH_ENV_NU_MODULE"
        ] [
          config.local.nushell.history_file_format
          "${flakePkgs.nu_plugin_bash_env}/bash-env.nu"
        ]
          (builtins.readFile ./config.nu));
        envFile.text = ''
          # Nushell Environment Config File

          def create_left_prompt [] {
              let hostname_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
              $"($hostname_color)(${config.local.nushell.left_prompt_cmd})(ansi reset)"
          }

        '' + (builtins.readFile ./env.nu);
      };

      direnv.enableNushellIntegration = true;
    };

    home = {
      packages = with pkgs; [
        flakePkgs.nu_plugin_bash_env
        jc
        job-security
      ];
    };
  };
}
