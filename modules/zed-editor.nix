{ config, lib, pkgs, ... }:

let
  cfg = config.local.zed-editor;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.zed-editor = {
    enable = mkEnableOption "zed-editor";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      # https://zed.dev/docs/reference/all-settings
      userSettings =
        {
          auto_update = false;
        };

      extensions = [ ];
    };

    home.packages = with pkgs; [
      nodejs
    ];
  };
}
