{ config, lib, pkgs, ... }:

let
  cfg = config.local.guile;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.guile = {
    enable = mkEnableOption "guile";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          guile
        ];

      file = {
        ".guile".text = (builtins.readFile ./dotguile.scm);
      };
    };
  };
}
