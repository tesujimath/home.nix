{ config, specialArgs, pkgs, lib, ... }:

with specialArgs; # for flakePkgs
{
  options.my.nushell = {
    left_prompt_cmd = lib.mkOption { default = "hostname -s"; type = lib.types.str; description = "Command to use to generate left prompt text"; };
    history_file_format = lib.mkOption { default = "sqlite"; type = lib.types.str; description = "History file format, either sqlite or plaintext"; };
    home_manager_flake_uri = lib.mkOption { default = "path:/UNSET"; type = lib.types.str; description = "URI for Home Manager flake for this system"; };
  };

  config = {
    programs = {
      nushell = {
        enable = true;
        configFile.text = (builtins.replaceStrings [
          "HISTORY_FILE_FORMAT"
          "HOME_MANAGER_FLAKE_URI"
        ] [
          config.my.nushell.history_file_format
          config.my.nushell.home_manager_flake_uri
        ] (builtins.readFile ./config.nu));
        envFile.text = ''
          # Nushell Environment Config File

          def create_left_prompt [] {
              let hostname_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
              $"($hostname_color)(${config.my.nushell.left_prompt_cmd})(ansi reset)"
          }

        '' + (builtins.readFile ./env.nu);

        package = pkgs.nushell.overrideAttrs (drv: rec {
          version = "0.94.3-real-parent";
          src = pkgs.fetchFromGitHub {
            owner = "tesujimath";
            repo = "nushell";
            rev = "real_parent.version";
            hash = "sha256-aW2B9f/KU5Aj2QrS5ZnzFabN+GrgajK1ttsRb0EJI+I=";
          };
          cargoDeps = drv.cargoDeps.overrideAttrs (attrs: {
            name = "${lib.strings.getName attrs.name}-0.94.3-real-parent.tar.gz";
            inherit src;
            outputHash = "sha256-RuEaIpNBFzRivphbAemQ+WHL1I86uCtfaf1Cik+GpIw=";
          });
        });
      };

      direnv.enableNushellIntegration = true;
    };

    home.file = {
      ".config/nushell/plugins/nu_plugin_bash_env".source = "${flakePkgs.nu_plugin_bash_env}/bin/nu_plugin_bash_env";

      ".config/nushell/plugins/nu_plugin_dbus".source =
        let nu_plugin_dbus = pkgs.callPackage ./plugins/dbus.nix { };
        in
          "${nu_plugin_dbus}/bin/nu_plugin_dbus";
    };

    home.packages = with pkgs; [
      jc
      job-security
    ];
  };
}
