{ config, pkgs, lib, ... }:

{
  home = {
    sessionPath = [
      "$HOME/scripts"
    ];
  };

  imports = [
    ./common.nix
  ];
}
