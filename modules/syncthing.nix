{ config, lib, pkgs, ... }:

let
  cfg = config.local.syncthing;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = pkgs.stdenv.isLinux;
    };
  };
}
