{ pkgs, ... }:

let
  inherit (pkgs)
    xdg-utils;
in
{
  # this module is always on, as many things depend on it
  config = {
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
