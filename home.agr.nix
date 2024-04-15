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
          alias = {
            glog = "log --graph --all --pretty='format:%C(auto)%h %D %<|(100)%s %<|(120)%an %ar'";
          };
        };
      };

      # in other profiles this is done in xmonad-desktop
      wezterm = {
        enable = true;
        enableBashIntegration = true;

        extraConfig = builtins.readFile ./dotfiles.agr/wezterm.lua;
      };

    };

    my = {
      lsp = {
        # mostly they're enabled by default, except:
        terraform.enable = true;
      };

      bash.profile.reuse-ssh-agent = true;
    };
  };
}
