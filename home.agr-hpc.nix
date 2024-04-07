{ config, pkgs, lib, ... }:

{
  home = {
    sessionPath = [
      "$HOME/scripts"
    ];
  };

  imports = [
    ./common.nix
  ];

  my.bash.profile.reuse-ssh-agent.enable = true;
}
