{ config, pkgs, lib, ... }:

{
  options.my.web-browser = {
    wsl.use-native-windows = lib.mkOption {
      type = lib.types.bool;
      description = "Use native Windows web browsers for WSL";
      default = false;
    };
    wsl.firefox.exec = lib.mkOption {
      type = lib.types.str;
      description = "XDG Desktop Entry exec string for native Windows Firefox";
      default = "\"${config.home.homeDirectory}/win/AppData/Local/Mozilla Firefox/firefox.exe\" %U";
    };
    wsl.google-chrome.exec = lib.mkOption {
      type = lib.types.str;
      description = "XDG Desktop Entry exec string for native Windows Google Chrome";
      default = "\"/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe\" %U";
    };
  };

  config = {
    home.packages =
      if config.my.web-browser.wsl.use-native-windows then [] else
        with pkgs;
        [
          firefox
          google-chrome
        ];

    xdg.desktopEntries = if config.my.web-browser.wsl.use-native-windows then {
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        exec = config.my.web-browser.wsl.firefox.exec;
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
      google-chrome = {
        name = "Google Chrome";
        genericName = "Web Browser";
        exec = config.my.web-browser.wsl.google-chrome.exec;
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
    } else {};

    xdg.mimeApps = {
      defaultApplications = {
        "text/html" = ["firefox.desktop" "google-chrome.desktop"];
      };
    };
  };
}
