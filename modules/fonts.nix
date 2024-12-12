{ config, lib, pkgs, ... }:

let
  cfg = config.local.fonts;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.fonts = {
    enable = mkEnableOption "fonts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        cantarell-fonts
        noto-fonts
        noto-fonts-color-emoji
        source-code-pro
      ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [
          "Source Code Pro"
          "Noto Color Emoji"
          "Noto Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
        ];
      };
    };
  };
}
