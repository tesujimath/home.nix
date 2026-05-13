{ config, lib, ... }:

let
  cfg = config.local.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      envExtra =
        if config.local.homebrew.enable then ''

          # homebrew integration
          eval "$(/opt/homebrew/bin/brew shellenv)"
        '' else "";
    };
  };
}
