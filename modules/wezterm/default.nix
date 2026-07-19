{ config, lib, ... }:

let
  cfg = config.tesujimath.wezterm;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkIf cfg.enable
    {
      programs = {
        wezterm = {
          enable = true;
          enableBashIntegration = true;

          extraConfig = builtins.readFile ./wezterm.lua;
        };
      };
    };
}
