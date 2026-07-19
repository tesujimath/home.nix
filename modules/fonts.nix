{ config, lib, pkgs, ... }:

let
  cfg = config.tesujimath.fonts;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.fonts = {
    enable = mkEnableOption "fonts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        cantarell-fonts
        nerd-fonts.iosevka
        nerd-fonts.symbols-only
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
