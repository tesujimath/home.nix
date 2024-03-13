{ config, pkgs, ... }:
{
  config = {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
      };
    };
  };
}
