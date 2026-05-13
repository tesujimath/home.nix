{ config, lib, pkgs, ... }:

let
  cfg = config.local.emacs;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (pkgs) stdenv;
in
{
  options.local.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkMerge [
    (mkIf cfg.enable
      {
        # all platforms
        programs = {
          emacs =
            let
              inherit (pkgs) emacsPackagesFor emacs;

              emacsWithPackages = (emacsPackagesFor emacs).withPackages (epkgs: [
                epkgs.jinx
              ]);

            in
            {
              enable = true;
              package = emacsWithPackages;
            };
        };

        home.packages = with pkgs; [
          enchant # modern spell check abstraction layer, on macOS uses system dictionary
        ];
      })
    (mkIf (cfg.enable && !stdenv.isDarwin)
      {
        # no XDG on macOS
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
      })
  ];
}
