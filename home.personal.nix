{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    #./modules/ep-dev-backend
    ./modules/emacs.nix
    ./modules/ledger
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

    sessionVariables = {
      EMAIL = "simon.guest@tesujimath.org";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Simon Guest";
      userEmail = "simon.guest@tesujimath.org";
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

  my = {
    nushell = {
      home_manager_flake_uri = "path:/home/sjg/vc/env/home.nix#personal";
    };
  };
}
