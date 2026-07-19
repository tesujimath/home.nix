{ config, pkgs, lib, ... }:

let
  cfg = config.tesujimath.mitmproxy;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.mitmproxy = {
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
