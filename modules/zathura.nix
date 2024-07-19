{ config, lib, ... }:
with lib;
let
  cfg = config.local.zathura;
in
{
  options.local.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf cfg.enable {
    programs = {
      zathura = {
        enable = true;
        #mappings = {
        #  "+" = "zoom in";
        #  "-" = "zoom out";
        #"<C-q>" = "quit";
        #"<PageUp>" = "scroll full-up";
        #"<PageDown>" = "scroll full-down";
        #};
        options = {
          window-height = "1080";
          window-width = "766";
          adjust-open = "width";
          scroll-wrap = "false";
          selection-clipboard = "clipboard";
          #statusbar_bgcolor = "#00FF00";
          #statusbar_fgcolor = "red";
        };
      };
    };

    xdg.mimeApps = {
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
  };
}
