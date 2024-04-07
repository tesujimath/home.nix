{ config, pkgs, ... }:

with pkgs;
{
  config = {
    programs = {
      emacs = {
        enable = true;
        package = ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
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
        icon="emacs";
        type = "Application";
        exec = "emacsclient -- %u";
        mimeType = ["x-scheme-handler/org-protocol"];
      };
    };

    home.packages = [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      sqlite # for org-roam
    ];
  };
}
