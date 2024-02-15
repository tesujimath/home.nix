{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs;
      [
        gcc
      ];

    sessionPath = [
      "$HOME/scripts"
    ];
  };

  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
