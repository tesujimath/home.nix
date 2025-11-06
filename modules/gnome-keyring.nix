{ config, lib, ... }:

let
  cfg = config.local.gnome-keyring;
  inherit (lib) mkEnableOption mkIf;
in
{
  options. local. gnome-keyring = {
    enable = mkEnableOption "gnome-keyring";
  };

  config = mkIf cfg.enable
    {
      # Enable GNOME Keyring services
      services.gnome-keyring = {
        enable = true;
        components = [ "ssh" "secrets" ];
      };

      # Set up the correct environment socket
      # TODO remove
      # systemd.user.sessionVariables.SSH_AUTH_SOCK =
      #   "/run/user/${config.home.uid}/keyring/ssh";
    };
}
