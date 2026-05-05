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
        '' + (if config.local.carapace.enable then ''

          # carapace integration
          carapace _carapace | source
        '' else "") + (if config.local.homebrew.enable then ''

          # homebrew integration
          eval "$(/opt/homebrew/bin/brew shellenv)"
        '' else "");

        functions = cfg.functions // {
          fish_prompt.body = "string join '' -- (set_color green) (string replace -r '\\..*$' '' $hostname) '> ' (set_color normal)";

          # work-around for
          # > command-not-found
          # DBI connect('dbname=/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite','',...) failed: unable to open database file at /run/current-system/sw/bin/command-not-found line 13.
          # cannot open database `/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.        };
          fish_command_not_found.body = ''echo "fish: Unknown command: $argv"'';

          home-manager-switch.body = ''
            home-manager switch -v --flake $HOME_MANAGER_FLAKE_REF_ATTR
            set -e __HM_SESS_VARS_SOURCED
            bash-env $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
          '';
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
              rev = "416af79117d42c16447f9de7b2f5f14a00d47d9c";
              sha256 = "sha256-jwr5ydVGbk4OF5BkLmyEEkEOW7FQywNdqW9HFlcxPvM=";
            };
          }
          {
            name = "module";
            src = pkgs.fetchFromGitHub {
              owner = "tesujimath";
              repo = "lmod-fish";
              rev = "6ebfc8accc68e86741cc667b7ae87e2f6272d4ec";
              sha256 = "sha256-Fnngn3qVRB/E5sUytAsa7WZnPiYZJeCbMg5Ofiv2uiI=";
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
