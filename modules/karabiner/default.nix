{ config, lib, pkgs, ... }:

let
  cfg = config.local.karabiner;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.karabiner = {
    enable = mkEnableOption "karabiner";
  };

  config = mkIf cfg.enable
    {
      home.file.".config/karabiner/karabiner.json".source = ./karabiner.json;
    };
}
