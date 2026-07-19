{ config, lib, pkgs, ... }:

let
  cfg = config.tesujimath.syncthing;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = pkgs.stdenv.isLinux;
    };
  };
}
