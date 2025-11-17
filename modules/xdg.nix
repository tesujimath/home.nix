{ pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs) xdg-utils;
in
{
  # this module is on for Linux, as many things depend on it
  config = mkIf pkgs.stdenv.isLinux {
    home.packages =
      [
        xdg-utils
      ];

    xdg = {
      enable = true;
      mimeApps.enable = true;
    };
  };
}
