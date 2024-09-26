{ config, lib, ... }:

let
  cfg = config.local.carapace;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.carapace = {
    enable = mkEnableOption "carapace";
  };

  config = mkIf cfg.enable {
    programs = {
      carapace = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
