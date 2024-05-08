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
      # we need it even though we run wezterm from native Windows, because having this
      # provides the TERMINFO to programs running inside wezterm
      wezterm = {
        enable = true;
        enableBashIntegration = true;

        extraConfig = builtins.readFile ./dotfiles.agr/wezterm.lua;
      };

    };

    my = {
      lsp = {
        # mostly they're enabled by default, except:
        packer.enable = true;
        terraform.enable = true;
      };

      bash.profile.reuse-ssh-agent = true;

      web-browser.wsl.use-native-windows = true;
    };
  };
}
