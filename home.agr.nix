{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ./modules/emacs.nix
    ./modules/web-browser.nix
    ./packages.nix
    ./packages.agr.nix
  ];

  config = {
    home = {
      sessionPath = [
        "$HOME/scripts"
      ];

      file = {
        ".ssh/config".source = ./dotfiles.agr/ssh_config;
      };
    };

    programs = {
      git = {
        enable = true;
        userName = "Simon Guest";
        userEmail = "simon.guest@agresearch.co.nz";
        extraConfig = {
          fetch = {
            prune = true;
          };
          init = {
            defaultBranch = "main";
          };
        };
      };
    };

    my = {
      lsp = {
        # mostly they're enabled by default, except:
        terraform.enable = true;
      };

      bash.profile.reuse-ssh-agent.enable = true;
    };
  };
}
