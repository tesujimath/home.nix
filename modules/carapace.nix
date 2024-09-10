{ config, lib, ... }:

with lib;
let
  cfg = config.local.carapace;
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
