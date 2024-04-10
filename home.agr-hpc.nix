{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
  ];

  config = {
    home = {
      sessionPath = [
        "$HOME/scripts"
      ];

      sessionVariables = {
        LC_ALL = "en_US.UTF-8";
      };
    };

    my.bash.profile.reuse-ssh-agent.enable = true;

}
