{ config, pkgs, ... }:
{
  config = {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        settings = {
          manager = {
            ratio = [1 2 5];
          };
        };
      };
    };
  };
}
