{ pkgs, ... }:

with pkgs;
{
  # currently a big dump of what I had in nix-env
  home.packages = [
    amber
    beekeeper-studio
    python3Packages.mitmproxy
    rclone
  ];
}
