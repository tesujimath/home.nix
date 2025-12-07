{ config, lib, pkgs, ... }:

let
  cfg = config.local.wezterm;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (pkgs) stdenv;
in
{
  options.local.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkMerge [
    (mkIf (cfg.enable && !stdenv.isDarwin)
      {
        programs = {
          wezterm = {
            enable = true;
            enableBashIntegration = true;

            extraConfig = builtins.readFile ./wezterm.lua;
          };
        };
      })
    (mkIf (cfg.enable && stdenv.isDarwin)
      {
        # on MacOS we use the Homebrew cask installed in nix-darwin
        home = {
          file.".config/wezterm/wezterm.lua".source = ./wezterm.lua;
        };
      })
  ];
}
