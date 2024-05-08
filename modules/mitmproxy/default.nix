{ config, pkgs, lib, ... }:

{
  config = {
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
