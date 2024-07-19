{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/syncthing.nix
    ./modules/xmonad-desktop
    ./modules/web-browser.nix
    ./packages.nix
    ./packages.personal.nix
    #./ep/apps.nix
    #./ep/aws.nix
    #./secrets.personal.nix
  ];
  home = {
    file = {
      ".env.sh".source = ./dotfiles.personal/env.sh;
    };

    file = {
      ".ssh/config".source = ./dotfiles.personal/ssh_config;
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
  };
}
