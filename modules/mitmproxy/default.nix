{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.local.mitmproxy;
in
{
  options.local.mitmproxy = {
    enable = mkEnableOption "mitmproxy";
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".mitmproxy/config.yaml".source = ./config.yaml;
      };

      packages =
        with pkgs;
        [
          python3Packages.mitmproxy
        ];
    };
  };
}
