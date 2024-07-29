{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.local.wezterm;
in
{
  options.local.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkIf cfg.enable {
    programs = {
      wezterm = {
        enable = true;
        enableBashIntegration = true;

        extraConfig = builtins.readFile ./wezterm.lua;
      };
    };
  };
}
