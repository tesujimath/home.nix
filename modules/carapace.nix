{ config, lib, ... }:

let
  cfg = config.tesujimath.carapace;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.carapace = {
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
