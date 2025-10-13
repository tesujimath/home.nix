{ config, lib, pkgs, ... }:

let
  cfg = config.local.babashka;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.babashka = {
    enable = mkEnableOption "babashka";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        babashka
      ];
  };
}
