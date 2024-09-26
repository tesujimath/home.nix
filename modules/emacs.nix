{ config, lib, pkgs, ... }:

let
  cfg = config.local.emacs;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    programs = {
      emacs = {
        enable = true;
        package = with pkgs;
          ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
            epkgs.emacsql-sqlite # for org-roam
          ]));
      };
    };

    xdg.desktopEntries = {
      org-protocol = {
        # https://orgmode.org/worg/org-contrib/org-protocol.html
        # https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg-desktop-entries.nix
        name = "org-protocol";
        comment = "Intercept calls from emacsclient to trigger custom actions";
        icon = "emacs";
        type = "Application";
        exec = "emacsclient -- %u";
        mimeType = [ "x-scheme-handler/org-protocol" ];
      };
    };

    # need to override the existing emacs.desktop registration for org-protocol
    # because that omits to pass the URL
    xdg.mimeApps = {
      defaultApplications = {
        "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
      };
    };

    home.packages =
      with pkgs;
      [
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
        sqlite # for org-roam
      ];
  };
}
