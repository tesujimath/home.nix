{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ./modules/web-browser.nix
    ./packages.nix
    ./packages.agr.nix
  ];

  config = {
    home = {
      sessionPath = [
        "$HOME/bin"
        "$HOME/scripts"
      ];

      file = {
        ".ssh/config".source = ./dotfiles.agr/ssh_config;
      };

      sessionVariables = {
        # in this profile I run a Windows terminal, so copy/paste must use terminal
        FX_NO_MOUSE = "true";
      };
    };

    programs = {
      git = {
        enable = true;
        userName = config.local.user.fullName;
        userEmail = config.local.user.email;
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
  };
}
