{ config, lib, ... }:

with lib;
let
  cfg = config.local.syncthing;
in
{
  options.local.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = true;

      extraOptions = [
        "--no-default-folder"
      ];
    };
  };
}
