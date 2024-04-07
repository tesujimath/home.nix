{ config, pkgs, lib, ... }:

{
  home.sessionPath = [
    "$HOME/scripts"
  ];

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

  home = {
    file = {
      ".ssh/config".source = ./dotfiles.agr/ssh_config;
    };
  };

  imports = [
    ./common.nix
    ./modules/web-browser.nix
    ./packages.agr.nix
  ];

  my.lsp = {
    # mostly they're enabled by default, except:
    terraform.enable = true;
  };
}
