{ config, lib, ... }:

let
  cfg = config.local.wezterm;
  inherit (lib) mkEnableOption mkIf;
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
