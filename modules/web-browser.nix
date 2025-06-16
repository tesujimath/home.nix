{ config, pkgs, lib, ... }:

let
  cfg = config.local.web-browser;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.web-browser = {
    enable = mkEnableOption "Web browser";

    wsl = {
      use-native-windows = lib.mkOption {
        type = lib.types.bool;
        description = "Use native Windows web browsers for WSL";
        default = false;
      };
      firefox.exec = lib.mkOption {
        type = lib.types.str;
        description = "XDG Desktop Entry exec string for native Windows Firefox";
        default = "\"${config.home.homeDirectory}/win/AppData/Local/Mozilla Firefox/firefox.exe\" %U";
      };
      google-chrome.exec = lib.mkOption {
        type = lib.types.str;
        description = "XDG Desktop Entry exec string for native Windows Google Chrome";
        default = "\"/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe\" %U";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      if config.local.web-browser.wsl.use-native-windows then [ ] else
        with pkgs;
        [
          brave
          widevine-cdm # for Brave to play Spotify
          firefox
          # google-chrome, incompatible with widevine-cdm which I need for Brave to play Spotify
        ];

    xdg.desktopEntries =
      if config.local.web-browser.wsl.use-native-windows then {
        firefox = {
          name = "Firefox";
          genericName = "Web Browser";
          exec = config.local.web-browser.wsl.firefox.exec;
          terminal = false;
          categories = [ "Application" "Network" "WebBrowser" ];
          mimeType = [ "text/html" "text/xml" ];
        };
        google-chrome = {
          name = "Google Chrome";
          genericName = "Web Browser";
          exec = config.local.web-browser.wsl.google-chrome.exec;
          terminal = false;
          categories = [ "Application" "Network" "WebBrowser" ];
          mimeType = [ "text/html" "text/xml" ];
        };
      } else { };

    xdg.mimeApps = {
      defaultApplications =
        let handlers-for = protocols: applications: lib.attrsets.genAttrs protocols (name: applications);
        in
        handlers-for [
          "application/x-extension-htm"
          "application/x-extension-html"
          "application/x-extension-shtml"
          "application/x-extension-xht"
          "application/x-extension-xhtml"
          "application/xhtml+xml"
          "text/html"
          "x-scheme-handler/chrome"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ] [
          "firefox.desktop"
          "brave.desktop"
          "google-chrome.desktop"
        ];
    };
  };
}
