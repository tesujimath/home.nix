{ config, ... }:

{
  config = {
    services.syncthing = {
      enable = true;
      tray.enable = true;

      extraOptions = [
        "--no-default-folder"
      ];
    };
  };
}
