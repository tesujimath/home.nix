{ config, pkgs, lib, ... }:

{
  config = {
    home.packages = with pkgs; [
      xdg-utils
    ];

    xdg = {
      enable = true;
      mimeApps.enable = true;
    };
  };
}
