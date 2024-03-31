{ config, pkgs, ... }:

{
  config = {
    home.packages =
      with pkgs;
      [
        firefox
        google-chrome
      ];

    xdg.mimeApps = {
      defaultApplications = {
        "text/html" = ["firefox.desktop" "google-chrome.desktop"];
      };
    };
  };
}
