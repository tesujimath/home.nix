{ pkgs, ... }:

with pkgs;
{
  # currently a big dump of what I had in nix-env
  home.packages = [
    amber
    #beekeeper-studio uninstallable as of 2024-07-01
    rclone
  ];
}
