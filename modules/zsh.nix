{ config, lib, ... }:

let
  cfg = config.tesujimath.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      envExtra = ''
        ${if config.tesujimath.homebrew.enable then ''

          # homebrew integration
          eval "$(/opt/homebrew/bin/brew shellenv)"
        '' else ""}
      '';

      profileExtra = ''

        # OrbStack integration
        source ~/.orbstack/shell/init.zsh 2>/dev/null || :
      '';
    };
  };
}
