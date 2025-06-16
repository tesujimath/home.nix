{ config, lib, pkgs, ... }:

let
  cfg = config.local.jujutsu;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.jujutsu = {
    enable = mkEnableOption "jujutsu";
  };

  config = mkIf cfg.enable {
    programs = {
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = config.local.user.fullName;
            email = config.local.user.email;
          };
        };
      };
    };

    home.packages = with pkgs; [
      # TUI for jj, haven't decided yet which one I like most
      lazyjj
      jjui
    ];
  };
}
