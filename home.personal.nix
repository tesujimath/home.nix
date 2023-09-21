{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    #./modules/ep-dev-backend
    ./modules/emacs.nix
    ./modules/ledger
    ./modules/syncthing.nix
    ./modules/xmonad-desktop
    ./packages.nix
    ./packages.personal.nix
    #./ep/apps.nix
    #./ep/aws.nix
    #./secrets.personal.nix
  ];
  home.file = {
    ".env.sh".source = ./dotfiles.personal/env.sh;
  };
}
