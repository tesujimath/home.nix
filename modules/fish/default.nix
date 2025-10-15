{ config, lib, pkgs, specialArgs, ... }:

let
  cfg = config.local.fish;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (specialArgs) flakePkgs;
in
{
  options. local. fish = {
    enable = mkEnableOption "fish";

    functions = mkOption { type = types.attrsOf (types.attrsOf types.str); default = { }; description = "Fish functions as per Home Manager"; };
  };

  config = mkIf cfg.enable {
    home.packages = [
      flakePkgs.bash-env-json
    ];

    programs = {
      fish = {
        enable = true;

        interactiveShellInit = ''
          # disable Fish greeting message
          set -g fish_greeting
        '';

        functions = cfg.functions // {
          fish_prompt.body = "string join '' -- (set_color green) (string replace -r '\\..*$' '' $hostname) '> ' (set_color normal)";


          # work-around for
          # > command-not-found
          # DBI connect('dbname=/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite','',...) failed: unable to open database file at /run/current-system/sw/bin/command-not-found line 13.
          # cannot open database `/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.        };
          fish_command_not_found.body = ''echo "fish: Unknown command: $argv"'';

          home-manager-switch.body = ''home-manager switch -v --flake $HOME_MANAGER_FLAKE_REF_ATTR'';
        };

        shellAbbrs = {
          # just playing around with merging this and the Babashka one
          ll = "ls -lh";
        };

        plugins = [
          {
            name = "bash-env";
            src = pkgs.fetchFromGitHub {
              owner = "tesujimath";
              repo = "bash-env-fish";
              rev = "6428bab4d106788894e3e1f2c07573a04fa12052";
              sha256 = "sha256-t9RMDEq4rEHqKFr9R7SR5wC3DkB8dFOB9mz9KAvVXJg=";
            };
          }
          {
            name = "bass";
            src = pkgs.fetchFromGitHub {
              owner = "edc";
              repo = "bass";
              rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
              sha256 = "sha256-3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
            };
          }
        ];
      };
    };
  };
}
