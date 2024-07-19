{ pkgs, ... }:

{
  # this module is always on, as many things depend on it
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
